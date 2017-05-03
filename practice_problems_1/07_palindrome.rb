# Write a method that takes a string and returns true if it is a
# palindrome. A palindrome is a string that is the same whether written
# backward or forward. Assume that there are no spaces; only lowercase
# letters will be given.
#
# Difficulty: easy.

# recursions

def palindrome?(string)
  if string.size <= 1
    true
  else
    string[0] == string[-1] && palindrome?(string[1..-2])
  end
end

# iteration

def palindrome?(string)
  loop do
    break true if string.size <= 1
    break false if string[0] != string[-1]
    string = string[1..-2]
  end
end

p palindrome?('')
p palindrome?('A')
p palindrome?('AbA')


# These are tests to check that your code is working. After writing
# your solution, they should all print true.

puts("\nTests for #palindrome?")
puts("===============================================")
    puts('palindrome?("abc") == false: ' + (palindrome?('abc') == false).to_s)
    puts('palindrome?("abcba") == true: ' + (palindrome?('abcba') == true).to_s)
    puts('palindrome?("z") == true: ' + (palindrome?('z') == true).to_s)
puts("===============================================")
