# write a recursive method that determines whether a given string is a palindrome.

def palindromic?(string)
  string.size <= 1 ||
  string[0] == string[string.size - 1] &&
      palindromic?(string[1..string.size - 2])
end

p palindromic?('') == true
p palindromic?('a') == true
p palindromic?('aa') == true
p palindromic?('anna') == true
p palindromic?('abcdefgfedcba') == true
p palindromic?('abcdefggfedcba') == true
