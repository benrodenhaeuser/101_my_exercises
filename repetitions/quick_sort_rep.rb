def swap(array, index1, index2)
  temp = array[index1]
  array[index1] = array[index2]
  array[index2] = temp
  array
end

def partition(array, left_pointer, right_pointer)
  pivot_pointer = right_pointer
  pivot = array[pivot_pointer]
  right_pointer -= 1

  loop do
    while array[left_pointer] < pivot
      left_pointer += 1
    end

    while array[right_pointer] > pivot
      right_pointer -= 1
    end

    if left_pointer >= right_pointer
      break
    else
      swap(array, left_pointer, right_pointer)
    end

  end

  swap(array, left_pointer, pivot_pointer) # we swap array[0] and array[2]
  left_pointer # we return 0
end

def quick_sort(array, left_pointer = 0, right_pointer = array.size - 1)
  if left_pointer < right_pointer
    pivot_pointer = partition(array, left_pointer, right_pointer)
    quick_sort(array, left_pointer, pivot_pointer - 1)
    quick_sort(array, pivot_pointer + 1, right_pointer)
  end
  array
end

# array = []
# p quick_sort(array) # []
#
# array = [10]
# p quick_sort(array) # [10]
#
# array = [3, 2, 1]
# p quick_sort(array) # [1, 2, 3]
#
# array = [1, 5, 2, 0, 6, 3]
# p quick_sort(array) # [0, 1, 2, 3, 5, 6]
#
# array = [9, 7, 5, 11, 12, 2, 14, 3, 10, 6]
# p quick_sort(array) # [2, 3, 5, 6, 7, 9, 10, 11, 12, 14]


# using the built-in partition method.
# return a *new* array

def quick_sort(array)
  if array.size < 2
    array
  else
    pivot = array.last
    partition = array[0...-1].partition { |elem| elem < pivot }
    quick_sort(partition.first) + [pivot] + quick_sort(partition.last)
  end
end

array = []
p quick_sort(array) # []

array = [10]
p quick_sort(array) # [10]

array = [3, 2, 1]
p quick_sort(array) # [1, 2, 3]

array = [1, 5, 2, 0, 6, 3]
p quick_sort(array) # [0, 1, 2, 3, 5, 6]

array = [9, 7, 5, 11, 12, 2, 14, 3, 10, 6]
p quick_sort(array) # [2, 3, 5, 6, 7, 9, 10, 11, 12, 14]
