# Write a method, `ordered_vowel_words(str)` that takes a string of
# lowercase words and returns a string with just the words containing
# all their vowels (excluding "y") in alphabetical order. Vowels may
# be repeated (`"afoot"` is an ordered vowel word).
#
# You will probably want a helper method, `ordered_vowel_word?(word)`
# which returns true/false if a word's vowels are ordered.
#
# Difficulty: 2/5

=begin

APPROACH

1.) requirements

- a word counts as an "ordered_vowel_word" if its vowels appear in the order in which they appear in the alphabet (e.g., "amends" is such a word, "complicated" is not)

- given a string (lowercase words separated by whitespace), return a string consisting of the ordered_vowel_words from the original string.

- notice that vowels may be repeated (example: "afoot" is ordered_vowel_word)

2.) examples

input argument:
"amends complicated"
return value:
"amends"

3.0.) ideas/snippets

  for string to qualify as ordered_vowel_word, word_vowels has to look like this:

  0 or more occurences of a followed by
  0 or more occurences of e followed by
  ...                     i ...
  ...                     o ...
  ...                     u ...

3.) steps to solve

- ordered_vowel_word? (determines for a word-string whether the word is an ordered vowel word)

  - array VOWELS = %w(a e i o u)

  step 1: obtain new string `word_vowels` by deleting vowels from given word
    => how to do this? we could do it in a loop

    - split our given string into characters
    - iterate over characters, appending vowels to a new string, while ignoring consonants

  step 2: match `word_vowels` against the regex /a*e*i*o*u*/
    => if there is a match, then we have an ordered vowel word
    => else we don't have ordered_vowel_word

- ordered_vowel_words (returns the ordered vowel words occuring in a string as a new string)

  - given input string
  - word_array: split string in words (i.e., split on whitespace)
  - initialize new empty array ord_vow_words
  - iterate over word_array:
    - if current word from word_array is ordered vowel word (helper method!):
      append current word to ord_vow_words
  - join ord_vow_words, putting single whitespace between elements

=end

VOWELS = %w(a e i o u)

def get_vowels(word)
  word_vowels = ''
  word.chars.each do |char|
    if VOWELS.include?(char)
      word_vowels << char
    end
  end
  word_vowels
end

def ordered_vowel_word?(word)
  word_vowels = get_vowels(word)
  word_vowels.match(/a*e*i*o*u*/).to_s == word_vowels
end

def ordered_vowel_words(phrase)
  words = phrase.split(' ')
  ord_vow_words = []
  words.each do |word|
    ord_vow_words << word if ordered_vowel_word?(word)
  end
  ord_vow_words.join(' ')
end

puts("\nTests for #ordered_vowel_words")
puts("===============================================")
    puts "ordered_vowel_words(\"amends\") == \"amends\": "  + (ordered_vowel_words("amends") == "amends").to_s
    puts "ordered_vowel_words(\"complicated\") == \"\": "  + (ordered_vowel_words("complicated") == "").to_s
    puts "ordered_vowel_words(\"afoot\") == \"afoot\": "  + (ordered_vowel_words("afoot") == "afoot").to_s
    puts "ordered_vowel_words(\"ham\") == \"ham\": "  + (ordered_vowel_words("ham") == "ham").to_s
    puts "ordered_vowel_words(\"crypt\") == \"crypt\": "  + (ordered_vowel_words("crypt") == "crypt").to_s
    puts "ordered_vowel_words(\"o\") == \"o\": "  + (ordered_vowel_words("o") == "o").to_s
    puts "ordered_vowel_words(\"tamely\") == \"tamely\": "  + (ordered_vowel_words("tamely") == "tamely").to_s

    phrase = "this is a test of the vowel ordering system"
    result = "this is a test of the system"
    puts "ordered_vowel_words(phrase) == result: "  + (ordered_vowel_words(phrase) == result).to_s
puts("===============================================")
