# we are given a sorted (!) array and a number
# our task is to find the index such that array[index] == number (if it exists)

# binary search: the algorithm

# we define a "search space" by specifying an upper bound and a lower bound
# we check in the middle of the search space
# if the value we search for is higher than the middle value, then we
# continue to the right, adapting our search space accordingly
# we break if we find the value or if the left boundary is larger than
# or equal to the right boundary

# note that on each pass, we halve the search space

# binary search: pseudocode

# binary_search(array, value)
# define the initial boundaries:
# left_boundary = 0
# right_boundary = array.size - 1
# now we loop:
# midpoint = "the middle between left and right"
# break midpoint if midpoint == value
# break nil if left_boundary > right_boundary
# if value > array[midpoint]
#   left_boundary = midpoint + 1
# else
#   right_boundary = midpoint - 1

# binary search: implementation

def binary_search(array, value)
  left_boundary = 0
  right_boundary = array.size - 1
  loop do
    midpoint = (left_boundary + right_boundary) / 2
    value_at_midpoint = array[midpoint]
    break midpoint if value_at_midpoint == value
    if value_at_midpoint < value
      left_boundary = midpoint + 1
    else value_at_midpoint > value
      right_boundary = midpoint - 1
    end
    break nil if left_boundary > right_boundary
  end
end

array = [0, 1, 4, 6, 8, 10]
p binary_search(array, 4) # expect 2 => yes
p binary_search(array, 8) # expect 4 => yes
p binary_search(array, 0) # expect 0 => yes
p binary_search(array, 3) # expect nil => yes
p binary_search(array, 11) # expect nil => yes
