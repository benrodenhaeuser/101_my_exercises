# given a string, find all permutations of the string

require 'benchmark'

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

# the algorithm above is inefficient if our input string contains duplicate letters. on top of this, we actually produce an output array with duplicates!

# solution 3: avoid making duplicates of the same permutation

# approach

# - before generating the permutations, make a frequency count for each letter that occurs in the input string (=> separate method)
# - change the generate_permutations method to work with a hash stock instead of an array stock.
# - keep track of the letter frequency as we use up the letters, i.e., decrementing frequency of each used letter by 1.
# - only work on letters whose count is > 0 (!)
# - the base case of the recursion is now reached once all letters have frequencey 0 (this is when we have exhausted our stock).
# - also, make the method return the permutations rather than merely store them.

def frequency_count(array_of_char)
  frequencies = Hash.new { |hash, key| hash[key] = 0 }
  array_of_char.each { |letter| frequencies[letter] += 1 }
  frequencies
end

def choose(choice, frequencies, perm)
  frequencies[choice] -= 1
  perm << choice
  nil
end

def unchoose(choice, frequencies, perm)
  frequencies[choice] += 1
  perm.slice!(-1)
  nil
end

def compute_permutations(frequencies, perm = '', permutations = [])
  if frequencies.values.all? { |count| count == 0 }
    permutations << perm.dup
  else
    frequencies.each_key do |choice|
      next if frequencies[choice] == 0
      choose(choice, frequencies, perm)
      compute_permutations(frequencies, perm, permutations)
      unchoose(choice, frequencies, perm)
    end
  end
  permutations
end

def permutations(string)
  compute_permutations(frequency_count(string.chars.sort))
end

# test

# p permutations('')
# puts
# p permutations('a')
# puts
# p permutations('ab')
# puts
# p permutations('abc')
# puts
# p permutations('abcd') # 24 results
# puts
# p permutations('aacd') # 12 results
# puts
# p permutations('aaaaaaaaa') # length = 9, 1 result
# puts
# p permutations('abcdefghi') # length = 9, 362880 results, ~7-9 seconds to return

# puts Benchmark.realtime { permutations('0123456789') }
# 33.3688959996216 => intense!
