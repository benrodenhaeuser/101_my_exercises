# informal description of bubble_sort algorithm:

# here is how bubble sort works:
# we make iterated "passes" through the array.
# on each pass, we compare each element a with the next element b.
# if a is larger than b, then we swap them.
# in this way, large elements "bubble up" towards the right.
# we finish up when we make a pass without swaps.

# bubble_sort pseudocode:

# bubble_sort(array)
#   loop:
#     set swapped flag to false
#     for each index i of the array:
#       check if array[i] > array[i + 1]
#         if so, swap them and set the "swapped" flag to true
#     break out of loop if the swapped flag is (still) false

# implementation:

def bubble_sort(array)
  swapped = nil
  loop do
    swapped = false
    array.each_index do |index|
      if index <= array.size - 2
        if array[index] > array[index + 1]
          swap(index, index + 1, array)
          swapped = true
        end
      end
    end
    break if swapped == false
  end
  array
end

def swap(index1, index2, array)
  stored_value = array[index1]
  array[index1] = array[index2]
  array[index2] = stored_value
end

# test
array1 = []
array2 = [10, 7, 4, 3, 11]

p bubble_sort(array1) # []
p bubble_sort(array2) # [3, 4, 7, 10, 11]
