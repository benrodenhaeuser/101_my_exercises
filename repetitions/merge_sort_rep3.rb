# merge sort works by merging the sorted left half and the sorted right half of the array

=begin

merge_sort(array):
if:
  array.size is <= 1, return array
else:
- left_half = from the start of array to the middle
- right_half = from the middle of the array to the end
- return merge(merge_sort(left_half), merge_sort(right_half))

---

merge(array1, array2):

merged = []


=end

def merge_sort(array)
  return array if array.size <= 1
  mid = array.size / 2
  left = array[0...mid]
  right = array[mid...array.size]
  merge(merge_sort(left), merge_sort(right))
end

def merge(array1, array2)
  merged = []

  while array1 != [] && array2 != []

    if array1.first < array2.first
      merged << array1.first
      array1 = array1.drop(1)
    else
      merged << array2.first
      array2 = array2.drop(1)
    end

  end

  merged + array1 + array2
end

p merge([1, 4, 6],[2, 5, 7, 9, 11]) # [1, 2, 4, 5, 6, 7, 9, 11]
p merge_sort([10, 0, 8, 4, 8, 2, 5, 7]) # [0, 2, 4, 5, 7, 8, 8, 10]
