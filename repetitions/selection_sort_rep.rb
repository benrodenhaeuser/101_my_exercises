# implement the selection sort algorithm

=begin

1.) rough algorithm description

-- considering the array starting at counter 0:
    find the index of the smallest value
    swap it with the element at 0

-- considering the array starting at counter 1:
    find the index of the smallest value
    swap it with the element at 1

-- and so on until we have reached the second-to-last element
  (i.e., we want to do this as long as counter is < array.size - 1)

2.) pseudocode

-- what we will need for sure: method swap(index1, index2, array)

-- pseudocode for insertion sort (taking swap for granted)

  for counter in (0...(array.size - 1))

    index = counter
    stored_index = index

    while index < array.size
      if array[index] < array[stored_index]
        then stored_index = index
      
      index += 1
    end

    swap(counter, index, array)
  end

=end

def swap(index1, index2, array)
  stored_value = array[index1]
  array[index1] = array[index2]
  array[index2] = stored_value
end

def selection_sort(array)

  for counter in (0...(array.size - 1))

    index = counter
    stored_index = index

    while index < array.size
      stored_index = index if array[index] < array[stored_index]
      index += 1
    end

    swap(counter, stored_index, array)
  end

  array

end

p selection_sort([10, 9, 8, 7, 6, 5, 4, 3]) == [3, 4, 5, 6, 7, 8, 9, 10]
p selection_sort([]) == []
