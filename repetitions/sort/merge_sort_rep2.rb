# merge sort works by recursion
# the core idea is simple to state:
# to sort an array, sort its left half and its right half and merge the resulting
# (sorted) subarrays

def merge_sort(array)
  if array.size <= 1
    array
  else
    midpoint = (array.size - 1) / 2
    merge(merge_sort(array[0..midpoint]), merge_sort(array[midpoint+1...array.size]))
  end
end

# working assumption: array1 and array2 are sorted
def merge(array1, array2)
  merged = []

  counter1 = 0
  counter2 = 0
  while counter1 <= array1.size - 1 && counter2 <= array2.size - 1
    if array1[counter1] < array2[counter2]
      merged << array1[counter1]
      counter1 += 1
    else
      merged << array2[counter2]
      counter2 += 1
    end
  end

  if counter1 > array1.size - 1 # nothing left there
    merged = merged + array2[counter2...array2.size]
  else
    merged = merged + array1[counter1...array1.size]
  end

  merged
end

# another option would be to use destructive methods within the `merge` method
# this makes the code quite a bit more concise.

def merge_sort2(array)
  if array.size <= 1
    array
  else
    midpoint = (array.size - 1) / 2
    merge2(merge_sort2(array[0..midpoint]), merge_sort2(array[midpoint+1...array.size]))
  end
end

# note array[0..midpoint] and array[midpoint+1...array.size] are *new* arrays.
# so it is safe to work with them destructively within merge2 below.
# we couldn't do it this way if somehow we needed to pass our original array to
# merge2

# also note that merge_sort returns a new array! the original array is not affected.

# working assumption: array1 and array2 are sorted
def merge2(array1, array2)
  merged = []

  while array1 != [] && array2 != []
    if array1[0] < array2[0]
      merged << array1.shift
    else
      merged << array2.shift
    end
  end

  if array1 == []
    merged = merged + array2
  else
    merged = merged + array1
  end

  merged
end

array = [10, 7, 4, 3, 11]
p merge_sort2(array) # [3, 4, 7, 10, 11]
p array
