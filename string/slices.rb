# Given an array and a number, slice up the array into segments of the length
# given by number. The return value of your method should be an array
# containing all the slices. If the given length does not evenly divide the
# length of your array, the last element of your array of slices may be
# shorter than the others.

# my solution

def slice(array, number)
  slices = []

  index1 = 0
  index2 = number

  loop do
    break if index1 >= array.length
    slices << array[index1...index2]
    index1 = index2
    index2 += number
  end

  slices

end

p slice([0, 1, 2, 3], 2)
p slice([2, 4, 6, 8, 10, 12, 14, 16], 3)


# Nick's solution

def slice(arr, n)
  result = []
  idx = 0
  while idx < arr.size
    result << arr[idx, n]
    idx += n
  end
  result
end
