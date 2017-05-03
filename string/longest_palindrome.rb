# Find a longest palindromic substring of a given string

# Notice that there may be several maximal-length palindromic substrings of a given string. The problem description does not prescribe a way of dealing with such a situation. The task is simply to find *some* maximal palindromic substring.

# there are solutions in linear time, but that's not what we are aiming for here (see https://en.wikipedia.org/wiki/Longest_palindromic_substring).

# solution 1 (brute force recursion)

def longest_palindrome(string)
  if string.reverse == string
    string
  else
    right_string = string.slice(1..string.size - 1)
    left_string = string.slice(0..string.size - 2)

    palindrome_right = longest_palindrome(right_string)
    palindrome_left = longest_palindrome(left_string)

    if palindrome_left.size >= palindrome_right.size
      palindrome_left
    else
      palindrome_right
    end
  end
end

# solution 2 (recursion with memoization)

# "In computing, memoization or memoisation is an optimization technique used primarily to speed up computer programs by storing the results of expensive function calls and returning the cached result when the same inputs occur again." (https://en.wikipedia.org/wiki/Memoization)

# (the following code runs a lot faster than solution 1 above)

def longest_palindrome(string, l_p = {})
  if string.reverse == string
    l_p[string] == string
    string
  else
    right_str = string[0..-2]
    left_str = string[1..-1]

    # the next two lines are responsible for the efficiency increase:
    l_p[right_str] = longest_palindrome(right_str, l_p) unless l_p[right_str]
    l_p[left_str] = longest_palindrome(left_str, l_p) unless l_p[left_str]

    if l_p[right_str].length >= l_p[left_str].length
      l_p[right_str]
    else
      l_p[left_str]
    end
  end
end

p longest_palindrome('anna') # 'anna'
p longest_palindrome("annabrznnzghynny") # 'anna'
p longest_palindrome('aogishgsaoifsjannaalium') # 'anna'
p longest_palindrome('bananas') # 'anana'
p longest_palindrome('abracadabra') # 'aca'
