# write a recursive method that determines whether a given string is a palindrome.

def palindrome?(string)
  string.size <= 1 ||
  string[0] == string[string.size - 1] &&
      palindrome?(string[1..string.size - 2])
end

p palindrome?('') == true
p palindrome?('a') == true
p palindrome?('aa') == true
p palindrome?('anna') == true
p palindrome?('abcdefgfedcba') == true
p palindrome?('abcdefggfedcba') == true
