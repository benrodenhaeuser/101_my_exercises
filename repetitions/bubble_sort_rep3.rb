# bubble sort works by swapping value pairs
# we make a number of passes through the array we want to sort
# at each pass, the following happens:
# for every index (starting with 0):
# compary array[index] and array[index + 1]
# if the first is larger than the second, swap them.
# we do as many passes as needed to reach a stable state.

def bubble_sort(array)
  swapped = nil
  loop do
    swapped = false
    for i in (1...array.size)
      if array[i] < array[i - 1]
        swap_values_at_indices(i, i - 1, array)
        swapped = true
      end
    end
    break if swapped == false
  end
  array
end

def swap_values_at_indices(index1, index2, array)
  stored_value = array[index1]
  array[index1] = array[index2]
  array[index2] = stored_value
end

array = [10, 5, 3, 1, 2, 10]
p bubble_sort(array) # [1, 2, 3, 5, 10, 10]
