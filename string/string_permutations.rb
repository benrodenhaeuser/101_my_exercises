# given a string, find all permutations of the string

def all_permutations(string)
  produce_all_permutations(string).sort
end

def produce_all_permutations(string)
  if string.size <= 1
    [string]
  else
    permus = []
    first = string[0]
    rest = string[1...string.size]
    all_permutations(rest).each do |permu|
      (0..permu.size).each do |position|
        permus << permu[0...position] + first + permu[position...permu.size]
      end
    end
    permus
  end
end

p all_permutations('') # [""]
puts
p all_permutations('a') # ["a"]
puts
p all_permutations('ab') # ["ab", "ba"]
puts
p all_permutations('abc') # ["abc", "acb", "bac", "bca", "cab", "cba"]
puts
p all_permutations('abcd')
# ["abcd", "abdc", "acbd", "acdb", "adbc", "adcb", "bacd", "badc", "bcad", "bcda", "bdac", "bdca", "cabd", "cadb", "cbad", "cbda", "cdab", "cdba", "dabc", "dacb", "dbac", "dbca", "dcab", "dcba"]

p all_permutations('abcdef').size == (1..6).reduce(1, :*) # true
p all_permutations('abcdefghi').size == (1..9).reduce(1, :*) # true

# ^ (1..n).reduce(1, :*) computes the factorial of 6
# the number of permutations of a string is factorial(string.size)
# so this function grows fast
# for strings of size >= 9, all_permutations above is too slow to be useable.
