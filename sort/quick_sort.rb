# quicksort

def swap(array, index1, index2)
  temp = array[index1]
  array[index1] = array[index2]
  array[index2] = temp
  array
end

def partition(array, left_pointer, right_pointer)
  pivot_position = right_pointer
  pivot = array[pivot_position]
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

  swap(array, left_pointer, pivot_position)
  left_pointer
end

def quick_sort(array, left_pointer = 0, right_pointer = array.size - 1)
  if right_pointer - left_pointer > 0
    new_pointer = partition(array, left_pointer, right_pointer)
    quick_sort(array, left_pointer, new_pointer - 1)
    quick_sort(array, new_pointer + 1, right_pointer)
  end
  array
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
