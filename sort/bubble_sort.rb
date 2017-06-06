def swap(index1, index2, array)
  temp = array[index1]
  array[index1] = array[index2]
  array[index2] = temp
  array
end

def bubble_sort(array)
  swaps = true
  while swaps == true
    swaps = false
    for index in (0...array.size - 1)
      if array[index] > array[index + 1]
        swap(index, index + 1, array)
        swaps = true
      end
    end
  end
  array
end

p bubble_sort([])
p bubble_sort([1])
p bubble_sort([10, 9, 8, 3, 6])

# bubble sort with a small optimization: since bubble sort sorts the array from right to left, we do not have to make full passes through the array on each iteration, but we can stop one index earlier every time.

def bubble_sort(array)
  (array.size).downto(0) do |stop_index|
    swapped = false

    (1...stop_index).each do |index|
      if array[index] < array[index - 1]
        array[index - 1], array[index] = array[index], array[index - 1]
        swapped = true
      end
    end

    break unless swapped
  end

  array
end
