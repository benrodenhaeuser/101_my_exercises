# Given an array of `ids`, find the smallest id not in use. That is: given an array of non-negative integers, find the smallest integer not contained in the array.

require 'benchmark'

# ----------------------------------------------------------------------------
# solution 1: brute force
# ----------------------------------------------------------------------------

# just try out numbers, starting from 0, until we find one that is not contained in the array

def smallest_free_id1(array)
  guess = 0
  while array.include?(guess)
    guess += 1
  end
  guess
end

# ----------------------------------------------------------------------------
# solution 2: sort and check
# ----------------------------------------------------------------------------

# sort the array and find the first index that does not match its value

def smallest_free_id2(array)
  array.sort.each_with_index do |value, index|
    return index unless index == value
  end
  array.count
end

# ----------------------------------------------------------------------------
# solution 3: external array
# ----------------------------------------------------------------------------

# set up an extra array `gaps` containing numbers from 0 to n - 1 (for an array of size n). walk through the array, and delete the numbers we see from the gaps array. The first element of gaps will then be the smallest free id.

def smallest_free_id3(array)
  gaps = (0..array.size).to_a
  array.each { |value| gaps.delete(value) if value < array.size }
  gaps.first
end

# what is costly here is shifting elements of the gaps array after deleting an element. if our array has, say, 100,000 elements, there are literally millions of shifts of individual elements.

# ----------------------------------------------------------------------------
# solution 4: array of flags
# ----------------------------------------------------------------------------

# similar to the above. but instead of deleting elements from the gaps array, we mark the numbers we have encountered. this is a lot faster, because we do not have to shift array elements around.

def smallest_free_id4(array)
  gaps = (0..array.size).map { true }
  array.each { |value| gaps[value] = false if value < array.size }
  gaps.each_index { |index| return index if gaps[index] == true }
end

# here, instead of shifting elements of the gap array, we merely access one array element by index and change it. so that's just n steps in total.

# ----------------------------------------------------------------------------
# solution 5: divide and conquer
# ----------------------------------------------------------------------------

# idea: partition the array using n/2 as a pivot, recursively find the smallest free id within the two partition cells.

def smallest_free_id5(array)
  gap5(array, 0) || array.size
end

def gap5(array, start)
  if array.empty?
    start
  elsif array.size == 1
    start if start < array.first
  else
    splitter = start + (array.size / 2)
    cells = array.partition { |num| num < splitter }
    gap5(cells.first, start) ||
    gap5(cells.last, start + cells.first.count)
  end
end

# ----------------------------------------------------------------------------
# solution 6: reduce and conquer
# ----------------------------------------------------------------------------

# idea: halve the problem by partitioning the list and checking the size of the left half to determine where to continue the search for the gap

def smallest_free_id6(array)
  if array.max == array.size - 1
    array.size
  else
    gap6(array, 0, array.size - 1)
  end
end

def gap6(array, lower, upper)
  if array.empty?
    lower
  else
    midpoint = (lower + upper) / 2
    cells = array.partition { |num| num <= midpoint }
    if cells.first.size < (midpoint - lower + 1)
      gap6(cells.first, lower, midpoint)
    else
      gap6(cells.last, midpoint + 1, upper)
    end
  end
end

# ----------------------------------------------------------------------------
# tests:
# ----------------------------------------------------------------------------

# solution 1

# array = []
# p smallest_free_id1(array) # => 0
#
# array = [0]
# p smallest_free_id1(array) # => 1
#
# array = [18, 4, 8, 9, 16, 1, 14, 7, 19, 3, 0, 5, 2, 11, 6]
# p smallest_free_id1(array) # => 10

# solution 2

# array = []
# p smallest_free_id2(array) # => 0
#
# array = [0]
# p smallest_free_id2(array) # => 1
#
# array = [18, 4, 8, 9, 16, 1, 14, 7, 19, 3, 0, 5, 2, 11, 6]
# p smallest_free_id2(array) # => 10

# solution 3

# array = []
# p smallest_free_id3(array) # => 0
#
# array = [0]
# p smallest_free_id3(array) # => 1
#
# array = [18, 4, 8, 9, 16, 1, 14, 7, 19, 3, 0, 5, 2, 11, 6]
# p smallest_free_id3(array) # => 10
#
# array = (0..100000).to_a
# p smallest_free_id3(array) # 100001 (takes forever)

# solution 4

# array = []
# p smallest_free_id4(array) # => 0
#
# array = [0]
# p smallest_free_id4(array) # => 1
#
# array = [18, 4, 8, 9, 16, 1, 14, 7, 19, 3, 0, 5, 2, 11, 6]
# p smallest_free_id4(array) # => 10
#
# array = (0..100000).to_a
# p smallest_free_id4(array) # 100001 (very fast)

# solution 5

# array = []
# p smallest_free_id5(array) # 0
#
# array = [0]
# p smallest_free_id5(array) # 1
#
# array = [0, 1, 2, 4]
# p smallest_free_id5(array) # 3
#
# array = [18, 4, 8, 9, 16, 1, 14, 7, 19, 3, 0, 5, 2, 11, 6]
# p smallest_free_id5(array) # 10
#
# array = (0..100000).to_a
# p smallest_free_id5(array) # 100001

# solution 6

# array = []
# p smallest_free_id6(array) # 0
#
# array = [0]
# p smallest_free_id6(array) # 1
#
# array = [0, 1, 2, 4]
# p smallest_free_id6(array) # 3
#
# array = [18, 4, 8, 9, 16, 1, 14, 7, 19, 3, 0, 5, 2, 11, 6]
# p smallest_free_id6(array) # 10
#
# array = (0..100000).to_a
# p smallest_free_id6(array) # 100001

# ----------------------------------------------------------------------------
# benchmarks
# ----------------------------------------------------------------------------

array = (0..100000).to_a
array.delete(1001)

# puts Benchmark.realtime { smallest_free_id1(array) } # brute force (slow)
puts Benchmark.realtime { p smallest_free_id2(array) } # sort and check
# puts Benchmark.realtime { smallest_free_id3(array) } # external array (slow)
puts Benchmark.realtime { p smallest_free_id4(array) } # array of flags
# puts Benchmark.realtime { p smallest_free_id5(array) } # divide and conquer
puts Benchmark.realtime { p smallest_free_id6(array) } # reduce and conquer

# array = [18, 4, 8, 9, 16, 1, 14, 7, 19, 3, 0, 5, 2, 11, 6]

# brute force        3.000255674123764e-06
# sort and check     6.9998204708099365e-06
# external array     1.400010660290718e-05
# array of flags     6.9998204708099365e-06
# divide and conquer 1.5000347048044205e-05
# reduce and conquer 6.9998204708099365e-06

# array = (0..100000).to_a

# brute force        28.290248999837786
# sort and check     0.009538999758660793
# external array     233.09013100015
# array of flags     0.024766999762505293
# divide and conquer 0.20936099998652935
# reduce and conquer 0.000294999685138464

# array = (0..100000).to_a
# array.delete(1001)

# sort and check:     0.002177000045776367
# array of flags:     0.016278999857604504
# reduce and conquer: 0.018616999965161085

# observations:
# - it's hard to beat the built-in search!
# - reduce and conquer 
