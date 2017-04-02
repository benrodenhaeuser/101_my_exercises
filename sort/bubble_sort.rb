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
