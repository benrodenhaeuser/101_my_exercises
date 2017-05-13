# Write a method that returns a list of all substrings of a string. The returned list should be ordered by where in the string the substring begins. This means that all substrings that start at position 0 should come first, then all substrings that start at position 1, and so on. Since multiple substrings will occur at each position, the substrings at a given position should be returned in order from shortest to longest.

=begin


algorithm (rough):
  - for every valid string index: produce the prefixes of maximal substring of string starting at the index

in more detail:

- helper method `prefixes` ("give me all prefixes of given string")

  computes all (non-empty) prefixes of a (non-empty) string
  (example: given `ben`, prefixes are `b`, `be` and `ben`):

  map the range (0...string.size) (iteration variable `index`) to
  an array
    - number `index` gets mapped to array element string[0..index]

  return resulting array

- main method `substrings`: "give me all substrings of given string"

  iterate over the range (0...string.size) (iteration variable `index`):
    - append prefixes of the string string[index...string.size] to array `substrings`

  return array `substrings`

=end

def prefixes(string)
  (0...string.size).map do |index|
    string[0..index]
  end
end

def substrings(string)
  substrings = []
  (0...string.size).each do |index|
    substrings += prefixes(string[index...string.size])
  end
  substrings
end

p substrings('ben') # => ["b", "be", "ben", "e", "en", "n"]
p substrings('abcde') # => ["a", "ab", "abc", "abcd", "abcde", "b", "bc", "bcd", "bcde", "c", "cd", "cde", "d", "de", "e"]
