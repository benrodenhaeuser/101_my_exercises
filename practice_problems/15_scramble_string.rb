# Write a method that takes in a string and an array of indices in the
# string. Produce a new string, which contains letters from the input
# string in the order specified by the indices of the array of indices.
#
# Difficulty: medium.

=begin

APPROACH

Given: a string (called string), an array of indices (called positions)
Return value: a new string (called scrambled)

Example:
input: 'abcd', [3, 2, 1, 0]
return: 'dcba'

Algorithm:
- Initialize new empty string scrambled
- Iterate over positions using each (parameter passed to block: elem):
  - retrieve string[elem] and push string[elem] to scrambled
- Return scrambled

Algorithm without each:
- Initialize new empty string scrambled
- loop counter 'position', initially 0
- Iterate over positions array using loop method
  - break if loop counter equals (or exceeds) size of positions array
  - retrieve string[positions[position]] and push it to scrambled
  - increment loop counter by 1
- Return scrambled

=end

# solution with each

def scramble_string(string, positions)
  scrambled = ''
  positions.each { |elem| scrambled << string[elem] }
  scrambled
end

# solution without each

def scramble_string(string, positions)
  scrambled = ''
  position = 0
  loop do
    break if position >= positions.size
    scrambled << string[positions[position]]
    position += 1
  end
  scrambled
end


puts("\nTests for #scramble_string")
puts("===============================================")
    puts(
      'scramble_string("abcd", [3, 1, 2, 0]) == "dbca": ' +
      (scramble_string("abcd", [3, 1, 2, 0]) == "dbca").to_s
    )
    puts(
      'scramble_string("markov", [5, 3, 1, 4, 2, 0]) == "vkaorm"): ' +
      (scramble_string("markov", [5, 3, 1, 4, 2, 0]) == "vkaorm").to_s
    )
puts("===============================================")
