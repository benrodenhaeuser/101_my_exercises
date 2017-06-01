def merge_sort(array)
  if array.size <= 1
    array
  else
    array1 = array[0...array.size/2]
    array2 = array[array.size/2...array.size]
    merge(merge_sort(array1), merge_sort(array2))
  end
end

def merge(order1, order2)
  merged = []
  while !order1.empty? && !order2.empty?
    if order1[0] < order2[0]
      merged << order1.shift
    else
      merged << order2.shift
    end
  end

  if order1.empty?
    merged = merged + order2
  end

  if order2.empty?
    merged = merged + order1
  end

  merged
end


p merge_sort([10, 9, 8, 7, 6, 5, 4, 3, 2, 1])
