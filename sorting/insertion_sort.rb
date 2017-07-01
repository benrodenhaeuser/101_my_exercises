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


# implement insertion sort using recursion

# replaces the outer loop with a recursion
def insertion_sort(array, index = 0)
  return array if index == array.size
  insert_to_the_left(array, index)
  insertion_sort(array, index + 1)
end

def insert_to_the_left(array, index)
  stored = array[index]
  position = index
  while position > 0 && array[position - 1] > stored
    array[position] = array[position - 1]
    position -= 1
  end
  array[position] = stored
end

# def insert_to_the_left(array, index) # attempt at recursive solution — not working ...
#   if array[index - 1] > array[index]
#     swap(array, index, index - 1)
#   else
#     swap(array, index, index - 1)
#     insert_to_the_left(array, index - 1)
#   end
# end

def swap(array, index1, index2)
  stored_value = array[index1]
  array[index1] = array[index2]
  array[index2] = stored_value
end

array = []
p insertion_sort(array)

array = [1]
p insertion_sort(array)

array = [10, 8, 4, 6, 2, 8]
p insertion_sort(array)
