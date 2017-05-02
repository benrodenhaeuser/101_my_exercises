# given a string, find all permutations of the string

# solution 1

def all_permutations(string)
  produce_all_permutations(string).sort
end

def produce_all_permutations(string)
  if string.size <= 1
    [string]
  else
    permus = []
    first = string[0]
    rest = string[1..-1]
    all_permutations(rest).each do |permu|
      (0..permu.size).each do |position|
        permus << permu[0...position] + first + permu[position...permu.size]
      end
    end
    permus
  end
end

# p all_permutations('')
# puts
# p all_permutations('a')
# puts
# p all_permutations('ab')
# puts
# p all_permutations('abc')
# puts
# p all_permutations('abcd')
# puts
# p all_permutations('abcde')
#
# 3.times { puts }

# solution 2

def generate_permutations(stock, chosen, permus)
  if stock.empty?
    permus << chosen
  else
    stock.each_with_index do |choice, index|
      generate_permutations(
        stock[0...index] + stock[index + 1...stock.size],
        chosen + choice,
        permus
      )
    end
  end
  nil
end

def permutations(string)
  permus = []
  generate_permutations(string.chars, '', permus)
  permus
end

# p permutations('')
# puts
# p permutations('a')
# puts
# p permutations('ab')
# puts
# p permutations('abc')
# puts
# p permutations('abcd')
# puts
# p permutations('abcde')
# puts
# p permutations('abcdefghi')
# ^ this one is still reasonably fast, just takes a long time to print

# 5.times { puts }

# NOTES

# what is the time complexity in O notation of this algorithm?

# given input of size n:
# - there are n! permutations of input string
# - n! calls to the base case (where string is written to permus)
# - each of the permutations takes n calls to build
# (but that is not quite true, because our algo has a tree-like shape! so we don't duplicate steps for permus that have a common prefix)
# - so generate_permutations seems to run in O(n * n!)

# We are talking here about the permutations method only.
# Printing all the permutations obviously also takes time!

# We do not take advantage of repetitions in the input string to reduce number of steps (right?). This has two consequences:

# - unncessary effort
# - duplicates in the solutions array we produce! (this could be fixed by using a different data structure, I suppose, but that would not take care of the first problem)


# solution 3: do not produce duplicates!

# approach

# - before generating the permutations, make a frequency count for each letter that occurs in the input string (=> separate method)
# - change the generate_permutations method to work with a hash stock instead of an array stock.
# - keep track of the letter frequency as we use up letters, i.e., decrementing frequency of each used letter by 1.
# - only work on letters whose count is > 0 (!)
# - the base case of the recursion is now reached once all letters have frequencey 0 (we have exhausted our stock).
# - also, make the method return the permutations rather than create them as a side-effect

def frequency_count(array_of_char)
  frequencies = Hash.new { |hash, key| hash[key] = 0 }
  array_of_char.each { |letter| frequencies[letter] += 1 }
  frequencies
end

def go_forward(frequencies, partial, choice)
  frequencies[choice] -= 1
  partial << choice
  nil
end

def trace_back(frequencies, partial, choice)
  frequencies[choice] += 1
  partial.slice!(-1)
  nil
end

def get_permutations(frequencies, partial = '', permutations = [])
  if frequencies.values.all? { |count| count == 0 }
    permutations << partial.dup
  else
    frequencies.each_key do |choice|
      next if frequencies[choice] == 0
      go_forward(frequencies, partial, choice)
      get_permutations(frequencies, partial, permutations)
      trace_back(frequencies, partial, choice)
    end
  end
  permutations
end

def permutations(string)
  get_permutations(frequency_count(string.chars.sort))
end

# test

p permutations('')
puts
p permutations('a')
puts
p permutations('ab')
puts
p permutations('abc')
puts
p permutations('abcd') # 24 results
puts
p permutations('aacd') # 12 results
puts
p permutations('aaaaaaaaa') # length = 9, 1 result
puts
# p permutations('abcdefghi') # length = 9, 362880 results, ~7-9 seconds to return
