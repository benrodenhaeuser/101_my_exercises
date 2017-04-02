=begin

Problem statement: Find the longest palindromic substring of a given string

- Method that takes a string as argument, and returns a string, with no side effects
- There is not necessarily a unique longest palindromic substring. So we will return
*all* the longest ones.
- Algorithm:
  - By recursion
  - If given string is palindrome, return [string]
  - Elsif longest palindromes of "string without first char"
    are longer than longest palindromes of "string without last char"
    then return longest palindromes string without first char
  - Elsif longest palindromes of string without last char are longer then return those
  - Elsif they have same length, return concatenation after removing duplicates

Pseudocode:

def palindromes(string)
  if reverse(string) == string
    return [string]
  else
    if palindromes(string without first character) are longer than
      palindromes(string without last character)
      then return palindromes(string without first character)
    elsif palindromes(string without last) are longer
      then return those
    elseif they have same length
      then return concatenation, after removing duplicates
    end
end

=end

def palindromes(string)
  if string.reverse == string
    [string]
  else
    right_string = string.slice(1..string.size - 1)
    left_string = string.slice(0..string.size - 2)

    palindromes_right = palindromes(right_string)
    palindromes_left = palindromes(left_string)

    palindromes_right_size = palindromes_right.first.size
    palindromes_left_size = palindromes_left.first.size

    if palindromes_right_size > palindromes_left_size
      palindromes_right
    elsif palindromes_right_size < palindromes_left_size
      palindromes_left
    else
      (palindromes_left + palindromes_right).uniq
    end
  end
end

p palindromes("annabrznnzghynny") # ["anna", "znnz", "ynny"]
p palindromes('aogishgsaoifsjannaalium') # ['anna'], close to tractability border
