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
