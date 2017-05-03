# Write a method that takes in an integer `offset` and a string.
# Produce a new string, where each letter is shifted by `offset`. You
# may assume that the string contains only lowercase letters and
# spaces.
#
# When shifting "z" by three letters, wrap around to the front of the
# alphabet to produce the letter "c".
#
# You'll want to use String's `ord` method and Integer's `chr` method.
# `ord` converts a letter to an ASCII number code. `chr` converts an
# ASCII number code to a letter.
#
# You may look at the ASCII printable characters chart:
#
#     http://en.wikipedia.org/wiki/ASCII#ASCII_printable_characters
#
# Notice that the letter 'a' has code 97, 'b' has code 98, etc., up to
# 'z' having code 122.
#
# You may also want to use the `%` modulo operation to handle wrapping
# of "z" to the front of the alphabet.
#
# Difficulty: hard. Because this problem relies on outside
# information, we would not give it to you on the timed challenge. :-)

LETTERS = (97..122).to_a.map { |number| number.chr }
LENGTH_OF_ALPHABET = 26
LETTER_TO_NUMBER = LETTERS.zip(1..LENGTH_OF_ALPHABET).to_h
NUMBER_TO_LETTER = LETTER_TO_NUMBER.invert

def encrypt(offset, letter)
  return letter if letter == ' '

  number_of_letter = LETTER_TO_NUMBER[letter]
  new_number = (number_of_letter + offset) % LENGTH_OF_ALPHABET
  new_letter = NUMBER_TO_LETTER[new_number]
end

def caesar_cipher(offset, string)
  encrypted = []
  string.chars.each do |char|
    encrypted << encrypt(offset, char)
  end
  encrypted.join
end

puts("\nTests for #caesar_cipher")
puts("===============================================")
    puts(
      'caesar_cipher(3, "abc") == "def": ' +
      (caesar_cipher(3, 'abc') == 'def').to_s
    )
    puts(
      'caesar_cipher(3, "abc xyz") == "def abc": ' +
      (caesar_cipher(3, 'abc xyz') == 'def abc').to_s
    )
puts("===============================================")
