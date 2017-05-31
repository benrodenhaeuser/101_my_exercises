=begin

The algorithm divides the input list into two parts: the sublist of items already sorted, which is built up from left to right at the front (left) of the list, and the sublist of items remaining to be sorted that occupy the rest of the list. Initially, the sorted sublist is empty and the unsorted sublist is the entire input list. The algorithm proceeds by finding the smallest (or largest, depending on sorting order) element in the unsorted sublist, exchanging (swapping) it with the leftmost unsorted element (putting it in sorted order), and moving the sublist boundaries one element to the right.

=end

def selection_sort(array)
  for index in (0...array.size)
    swap_index = find_index_of_smallest(array, index)
    swap(index, swap_index, array)
  end
  array
end

def find_index_of_smallest(array, index)
  index_of_smallest = index
  while index < array.size
    index_of_smallest = index if array[index] < array[index_of_smallest]
    index += 1
  end
  index_of_smallest
end

def swap(index1, index2, array)
  stored = array[index1]
  array[index1] = array[index2]
  array[index2] = stored
end


p selection_sort([])
p selection_sort([1])
p selection_sort([3, 5, 10, 0, 9]) # [0, 3, 5, 9, 10]
