# Write a method that takes a string and returns the number of vowels
# in the string. You may assume that all the letters are lower cased.
# You can treat "y" as a consonant.
#
# Difficulty: easy.

# Regular Expression

def count_vowels(string)
  string.scan(/[aeiou]/i).size
end

# Iteration

def count_vowels(string)
  number_of_vowels = 0
  string.chars.each do |char|
    number_of_vowels += 1 if %w(a e i o u).include?(char)
  end
  number_of_vowels
end

puts("\nTests for #count_vowels")
puts("===============================================")
    puts('count_vowels("abcd") == 1: ' + (count_vowels('abcd') == 1).to_s)
    puts('count_vowels("color") == 2: ' + (count_vowels('color') == 2).to_s)
    puts('count_vowels("colour") == 3: ' + (count_vowels('colour') == 3).to_s)
    puts('count_vowels("cecilia") == 4: ' + (count_vowels('cecilia') == 4).to_s)
puts("===============================================")
