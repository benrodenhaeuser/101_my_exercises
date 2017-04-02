# selection sort:
# for i in (0...array.size):
# find the index >= i with the smallest value
# swap that value with value at index i

def swap(index1, index2, array)
  stored = array[index1]
  array[index1] = array[index2]
  array[index2] = stored
  array
end

def find_index_of_min(array)
  temp = 0
  for index in (1...array.size)
    if array[index] < array[temp]
      temp = index
    end
  end
  temp
end

def selection_sort(array)
  for index in (0...array.size)
    index_of_min = find_index_of_min(array[index...array.size]) + index
    swap(index, index_of_min, array)
  end
  array
end

array = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]

p selection_sort(array)

array = [10, 5, 7, 3, 2, 1, 20, 40, 1]

p selection_sort(array)
