def swap(index1, index2, array)
  stored = array[index1]
  array[index1] = array[index2]
  array[index2] = stored
  array
end

def bubble_sort(array)
  swapped = true
  while swapped
    swapped = false
    for i in (0...array.size - 1)
      if array[i] > array[i + 1]
        swap(i, i + 1, array)
        swapped = true
      end
    end
  end
  array
end

arr = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
arr.reverse!
p arr
p bubble_sort(arr)
