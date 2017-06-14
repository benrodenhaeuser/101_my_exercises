# Given an array of `ids`, find the smallest id not in use. That is: given an array of non-negative integers, find the smallest integer not contained in the array.

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
# solution 3: flag array
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
# solution 4: divide and conquer
# ----------------------------------------------------------------------------

# idea: partition the array using n/2 as a pivot, recursively find the smallest free id within the two partition cells.

# but how?

def smallest_free_id5(array, start = 0)
  if array.size == 1
    if array.first == 0
      1
    else
      0
    end
  else
    true # partition and recursively call smallest_free_id5 — but how?
  end
end

# additional parameter `start` specifying the starting value.
# do one-element arrays contain gaps? it depends on the starting value, I suppose.

# how to do this exactly?

# ----------------------------------------------------------------------------
# tests:
# ----------------------------------------------------------------------------

# array = []
# p smallest_free_id1(array) # => 0
#
# array = [0]
# p smallest_free_id1(array) # => 1
#
# array = [18, 4, 8, 9, 16, 1, 14, 7, 19, 3, 0, 5, 2, 11, 6]
# p smallest_free_id1(array) # => 10

# array = []
# p smallest_free_id2(array) # => 0
#
# array = [0]
# p smallest_free_id2(array) # => 1
#
# array = [18, 4, 8, 9, 16, 1, 14, 7, 19, 3, 0, 5, 2, 11, 6]
# p smallest_free_id2(array) # => 10

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
