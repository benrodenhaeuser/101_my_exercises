# Find a longest palindromic substring of a given string

=begin

Understanding the Problem

- a palindrome is a word that reads the same in both directions
- example: 'anna', 'a', 'b'
- we do not care which longest palindrome is returned, just that
  1) palindrome is returned
  2) there is no longer palindromic substring

Plan of Attack

- Brute force based on list of all substrings:
  - produce all substrings of word
  - select all palindromes from the list of substrings
  - find longest string in the list of palindromes (i.e., max by length)


- Recursive solution
  - the longest palindrome of a word is either:
    - the word (if its a palindrome)
    - the longer one of longest_palindrome(left) and longest_palindrome(right)

      where
        left = word without last character
        right = word without first character

=end

# Brute force based on list of all substrings
def initial_substrings(word)
  (0...word.length).map { |index| word[0..index] }
end

def substrings(word)
  (0...word.length).inject([]) do |memo, index|
    memo + initial_substrings(word[index...word.length])
  end
end

def palindrome?(word)
  word == word.reverse
end

def longest_palindrome(word)
  substrings = substrings(word)
  palindromes = substrings.select { |word| palindrome?(word) }
  palindromes.max_by { |word| word.length }
end

p longest_palindrome('anna')
p longest_palindrome('annaanna')
p longest_palindrome('bnnaannbq')

# Divide and conquer
def longest_palindrome(word)
  if palindrome?(word)
    word
  else
    left = word[0..-2]
    right = word[1..-1]
    [longest_palindrome(left), longest_palindrome(right)].max_by do |str|
      str.size
    end
  end
end

p longest_palindrome('anna')
p longest_palindrome('annaanna')
p longest_palindrome('bnnaannbq')
