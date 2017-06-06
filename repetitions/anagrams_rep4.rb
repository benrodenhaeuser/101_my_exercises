# given an array of words, built a two-dimensional array containing groups
# of words that are anagrams of each other (excluding words that have no
# anagrams in the original array)

=begin

Understanding the problem:
- what is an anagram? two words are anagrams of each other if they are built from the same chars. e.g. 'boot' and 'obto' are anagrams of each other.
- actually, this is the same as one being a permutation of the other, except that permutations are not usually required to be words (from the dictionary)
- useable definition for solving problem: two strings are anagrams of each other if they sort to the same string (via array representation).

task:
- given an array of strings
- return list of lists of words that are anagrams in that array

algorithm to achieve this?

- build a hash that sorts an array of words as values (words are anagrams of each other)
- use sorted string as key
- afterwards, return the values of the hash collected in an array.
- (perhaps select those hash values that have more than one element?)

pseudo-code:

- given array
- initialize hash (hash):
- for each element of the array (word):
    add word to hash[word.chars.sort]
- return hash.values

=end

def anagrams(array)
  hash = Hash.new { |hash,key| hash[key] = [] }
  array.each do |word|
    hash[word.chars.sort] << word
  end
  hash.values.select { |anas| anas.size > 1 }
end

array = %w[ben, neb, boot, obto, boan, noab, aon, boot, fun]

p anagrams(array)
