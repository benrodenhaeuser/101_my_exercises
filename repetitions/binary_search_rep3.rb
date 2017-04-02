# search for a value in a sorted array of numbers
# we define a search space, which we keep changing throughout the search
# initially, the search space spans the whole array
# we then inspect the middle value of our search space
# using the fact that our array is sorted, we shrink the search space
# step by step

def binary_search(array, value)
  left_boundary = 0
  right_boundary = array.size - 1
  loop do
    midpoint = (left_boundary + right_boundary) / 2
    value_at_midpoint = array[midpoint]
    p midpoint
    if value_at_midpoint > value
      right_boundary = midpoint - 1
      # ^ will have to look for value in the left half
    elsif value_at_midpoint < value
      left_boundary = midpoint + 1
      # ^ will have to look for value in the right half
    elsif value_at_midpoint == value
      break midpoint
    end
    break nil if left_boundary > right_boundary
  end
end

array = [0, 5, 10, 15, 20, 25]
p binary_search(array, 0) # 0
p binary_search(array, 10) # 2
p binary_search(array, 12) # nil
p binary_search(array, 25) # 5
p binary_search(array, 26) # nil
