# Write a method that takes in a string and returns the number of
# letters that appear more than once in the string. You may assume
# the string contains only lowercase letters. Count the number of
# letters that repeat, not the number of times they repeat in the
# string.
#
# Difficulty: hard.

=begin

APPROACH

REQUIREMENTS:
- given: string
- return value: integer
- integer represents number of letters in string that occur more than once

EXAMPLES:
input 'benjamin', return 1 (the 'n' occurs twice)
input 'anna', return 2 ('a' and 'n' both occur twice)
input '', return 0 (trivially, no letter occurs twice)

ALGO:

basic idea:
- need to keep track of letters we have seen already. if we see a letter, we have already seen, we increment the count of repeated letters (which we have to initialize to 0 in the beginning). in the end (i.e., having iterated throuth our given string), return that count.

steps to solve:

- initialize variable `count` to 0
- initialize array `already_seen` to empty array
- iterate over chars in given string:
  - if char is an element of already_seen, then increment count by 1
  - else push char to already_seen
- return count

mistake in above algo:
we should count letters that occur thrice only once towards our `count`

==> need to keep track of whether we have counted char already.

=end


def num_repeats(string)
  count = 0
  seen = Hash.new { |hash, key| hash[key] = 0 }
  string.chars.each do |char|
    count += 1 if seen[char] == 1
    seen[char] += 1
  end
  count
end

# another way would be to keep track of the `seen` chars as well as the `counted` chars:

def num_repeats(string)
  count = 0
  seen = []
  counted = []
  string.chars.each do |char|
    if seen.include?(char) & !counted.include?(char)
      count += 1
      counted << char
    end
    seen << char
  end
  count
end

# These are tests to check that your code is working. After writing
# your solution, they should all print true.
puts("\nTests for #num_repeats")
puts("===============================================")
    puts('num_repeats("abdbc") == 1: ' + (num_repeats('abdbc') == 1).to_s)
    # one character is repeated
    puts('num_repeats("aaa") == 1: ' + (num_repeats('aaa') == 1).to_s)
    puts('num_repeats("abab") == 2: ' + (num_repeats('abab') == 2).to_s)
    puts('num_repeats("cadac") == 2: ' + (num_repeats('cadac') == 2).to_s)
    puts('num_repeats("abcde") == 0: ' + (num_repeats('abcde') == 0).to_s)
puts("===============================================")
