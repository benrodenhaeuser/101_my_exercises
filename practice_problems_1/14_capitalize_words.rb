# Write a method that takes in a string of lowercase letters and
# spaces, producing a new string that capitalizes the first letter of
# each word.
#
# You'll want to use the `split` and `join` methods. Also, the String
# method `upcase`, which converts a string to all upper case will be
# helpful.
#
# Difficulty: medium.

# solution 1: use String#capitalize

def capitalize_words(string)
  string.split.map { |word| word.capitalize }.join(' ')
end

# solution 2: as suggested – using chars, upcase, join

def capitalize_words(string)
  chars = string.chars
  chars.map.with_index do |char, index|
    if index == 0 || chars[index - 1] == ' '
      char.upcase
    else
      char
    end
  end.join
end

# These are tests to check that your code is working. After writing
# your solution, they should all print true.

puts("\nTests for #capitalize_words")
puts("===============================================")
    puts(
      'capitalize_words("this is a sentence") == "This Is A Sentence": ' +
      (capitalize_words("this is a sentence") == "This Is A Sentence").to_s
    )
    puts(
      'capitalize_words("mike bloomfield") == "Mike Bloomfield": ' +
      (capitalize_words("mike bloomfield") == "Mike Bloomfield").to_s
    )
puts("===============================================")
