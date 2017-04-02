# insertion sort

# high-level view of insertion sort in place:
# - iterate over array indices starting with 1
# - save the value in array[index]
# - shift values at indices smaller than index 1 place to the right
# - until you find value smaller than saved value
# - insert saved value in gap

# - loop invariant: "the array array[0...index]" is sorted

# sort given array
def sort(array)
  for index in (1...array.size)
    stored = array[index]
    position = index
    while position > 0 && array[position - 1] > stored
      array[position] = array[position - 1]
      position -= 1
    end
    array[position] = stored
  end
  array
end

p sort([4, 2, 3, 1])
p sort([1, 3, 5, 4, 5])
p sort([])
p sort([1])
