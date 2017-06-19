# given a string, find all permutations of the string

require 'benchmark'

# ---------------------------------------------------------------------------
# solution 1
# ---------------------------------------------------------------------------

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

# ---------------------------------------------------------------------------
# solution 2
# ---------------------------------------------------------------------------

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

# ---------------------------------------------------------------------------
# solution 3: avoid making duplicates of the same permutation
# ---------------------------------------------------------------------------

# solution 1 and 2 do produce redundant permutations if our input string contains duplicate letters. one solution to this would be to remove redundancies after generating them. a better solution is to not generate redundant permutations in the first place.

# approach

# - before generating the permutations, make a frequency count for each letter that occurs in the input string (=> separate method)
# - change the generate_permutations method to work with a hash stock instead of an array stock.
# - keep track of the letter frequency as we use up the letters, i.e., decrementing frequency of each used letter by 1.
# - only work on letters whose count is > 0 (!)
# - the base case of the recursion is now reached once all letters have frequencey 0 (this is when we have exhausted our stock).
# - also, make the method return the permutations rather than merely store them.

def get_stock(array_of_char)
  stock = Hash.new { |hash, key| hash[key] = 0 }
  array_of_char.each { |letter| stock[letter] += 1 }
  stock
end

def choose(character, stock, permutation)
  stock[character] -= 1
  permutation << character
  nil
end

def unchoose(character, stock, permutation)
  stock[character] += 1
  permutation.slice!(-1)
  nil
end

def compute_permutations(stock, permutation = '', permutations = [])
  if stock.values.all? { |count| count == 0 }
    permutations << permutation.dup
  else
    stock.each_key do |character|
      next if stock[character] == 0
      choose(character, stock, permutation)
      compute_permutations(stock, permutation, permutations)
      unchoose(character, stock, permutation)
    end
  end
  permutations
end

def permutations(string)
  compute_permutations(get_stock(string.chars.sort))
end

# ---------------------------------------------------------------------------
# test
# ---------------------------------------------------------------------------

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
