# von Neumann's algorithm

# "two sort a list, merge the sorted left half of the list with the sorted right half of the list"
def merge_sort(ary)
  if ary.size <= 1
    ary
  else
    ary_1 = ary[0...ary.size / 2]
    ary_2 = ary[ary.size / 2...ary.length]
    merge(merge_sort(ary_1), merge_sort(ary_2))
  end
end

# iterative merge of two sorted lists
def merge(arr1, arr2)
  result = []
  while arr1 != [] && arr2 != []
    if arr1[0] < arr2[0]
      result << arr1[0]
      arr1 = arr1.drop(1)
    else
      result << arr2[0]
      arr2 = arr2.drop(1)
    end
  end
  if arr1 == []
    result += arr2
  else
    result += arr1
  end
  result
end

p 'merge_sort([]): ' + merge_sort([]).to_s
p 'merge_sort([1]): ' + merge_sort([1]).to_s
p 'merge_sort([5, 2, 7, 0]): ' + merge_sort([5,2,7,0]).to_s
p 'merge_sort([5, 2, 7, 0, 11, 1, 10, 5]): ' + merge_sort([5, 2, 7, 0, 11, 1, 10, 5]).to_s
p 'merge_sort([10, 2, 7, 4, 5]): ' + merge_sort([10, 2, 7, 4, 5]).to_s
