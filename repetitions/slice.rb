# Given an array of numbers, write a method that slices up the array into subarrays of a given length, returning a nested array containing thoses slices. if the length of the array is not evenly divisible by the given length, the last element of the return value may be shorter than the others.

=begin

approach:

**problem description:**

given: array of numbers (`array`) and a positive integer (`length`)
return: nested array containing arrays of numbers

- elements of return value are slices of the input argument `array` of length given by integer `length`
- last element of return value may be shorter than others, due to length of input array not evenly divisible by given integer

**examples:**

given array [0, 1, 2, 3] and length 2, return [[0, 1], [2, 3]].
given array [0, 1, 2, 3, 4] and length 2, return [[0, 1], [2, 3], [4]].

**edge case:**

what if given length of slices is 0? Slicing up an array into slices of length 0 does not seem possible/reasonable. ==> Return nil if called with length 0.

**algo:**

solution 1:

Use `each_slice` which will allow us to do exactly what we need.

solution 2:

Achieve the intended result with a loop.

- local variable `index` to point to the starting index of the current slice
- length of slice given by `length`
- iterate over the array using `loop` method
- retrieve slice of given length.
- increment `index` variable by `length`

  break condition:
  - break out of the loop once index >= array.length

solution 3:

Again with a loop, but on a slightly different pattern.

- instead of tracking our progress through the array, we can also take the first n elements (where n is the given length) on each iteration, and reassign the array.
- break condition: "array is empty or nil" (!)

=end


# solution 1:

def slice(array, length)
  return nil if length <= 0

  sliced = []
  array.each_slice(length) { |slice| sliced << slice }
  sliced
end

p slice([0, 1, 2, 3], 2)
p slice([0, 1, 2, 3, 4], 2)
p slice([0, 1, 2, 3], 0) # => nil
puts

# solution 2:

def slice(array, length)
  return nil if length <= 0

  sliced = []
  index = 0
  loop do
    break if index >= array.length
    sliced << array[index, length]
    index += length
  end
  sliced
end

p slice([0, 1, 2, 3], 2)
p slice([0, 1, 2, 3, 4], 2)
p slice([0, 1, 2, 3], 0) # => nil
puts

# slice 3:

def slice(array, length)
  return nil if length <= 0

  sliced = []
  loop do
    break if array.to_a == []
    sliced << array.first(length)
    array = array[length..-1] # might be nil!
  end

  sliced
end

# ^ the break condition makes use of the fact that nil.to_a == []

p slice([0, 1, 2, 3], 2)
p slice([0, 1, 2, 3, 4], 2)
p slice([0, 1, 2, 3], 0) # => nil
puts
