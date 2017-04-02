words =  ['demo', 'none', 'tied', 'evil', 'dome', 'mode', 'live',
          'fowl', 'veil', 'wolf', 'diet', 'vile', 'edit', 'tide',
          'flow', 'neon', 'blue', 'green']

# our task is to display the words that are anagrams of each other together.
# in other words, we want to print a number of lists to standard output,
# one for each list of words that are anagrams of each other.
# so in the end, we want to have a two-dimensional array, the elements of which
# are lists of anagrams. And we want to puts that two-dimensional array.

# how do we get there? we need a way to determine which words are anagrams
# of each other. And we need to store the anagrams in a convenient way.
# for the first task: sort the characters in a word alphabetically.
# then two words are anagrams of each other if sorting them in this way
# produces the same string.
# for the second task: use a hash!

# here is how one could do it:

def anagrams(array_of_words)
  ana_hash = Hash.new { |hash, key| hash[key] = [] }
  array_of_words.each { |word| ana_hash[word.split("").sort.join] << word }
  ana_hash.map { |key, list| list }.select { |list| list.size > 1 }
end

p anagrams(words)
