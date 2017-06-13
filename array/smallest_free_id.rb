# Given an array of ids (i.e., non-negative integers), find the smallest id not
# in use (i.e., the smallest integer not in the array)

# ----------------------------------------------------------------------------
# solution 1: brute force
# ----------------------------------------------------------------------------

def smallest_free_id1(array)
  guess = 0
  while array.include?(guess)
    guess += 1
  end
  guess
end

# array = []
# p smallest_free_id1(array) # => 0
#
# array = [0]
# p smallest_free_id1(array) # => 1
#
# array = [18, 4, 8, 9, 16, 1, 14, 7, 19, 3, 0, 5, 2, 11, 6]
# p smallest_free_id1(array) # => 10

# ----------------------------------------------------------------------------
# solution 2: sort and check
# ----------------------------------------------------------------------------

def smallest_free_id2(array)
  array.sort.each_with_index do |value, index|
    return index unless index == value
  end
  array.count
end

# array = []
# p smallest_free_id2(array) # => 0
#
# array = [0]
# p smallest_free_id2(array) # => 1
#
# array = [18, 4, 8, 9, 16, 1, 14, 7, 19, 3, 0, 5, 2, 11, 6]
# p smallest_free_id2(array) # => 10

# ----------------------------------------------------------------------------
# solution 3: flag array
# ----------------------------------------------------------------------------

# we set up an extra array `gaps` that records what we see as we walk through the array of ids. we delete every element we encounter from `gaps`. whatever remains in `gaps` after walking through the array is a gap. since `gaps` is sorted, `gaps.first` is the smallest gap, so it is the smallest free id.

def smallest_free_id3(array)
  gaps = (0..array.size).to_a
  array.each { |value| gaps.delete(value) if value < array.size }
  gaps.first
end

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

# what is costly here is shifting elements of the gaps array after deleting an element, there are literally millions of shifts we have to perform!

# ----------------------------------------------------------------------------
# solution 4: array of flags
# ----------------------------------------------------------------------------

# very similar to solution 3 in spirit, but *a lot* faster.

def smallest_free_id4(array)
  gaps = (0..array.size).map { true }
  array.each { |value| gaps[value] = false if value < array.size }
  gaps.each_index { |index| return index if gaps[index] == true }
end

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

# here, instead of shifting elements of the gap array, we merely access one array element by index and change it. so that's just n steps in total.

# ----------------------------------------------------------------------------
# solution 4: divide and conquer
# ----------------------------------------------------------------------------

# idea: partition the array using n/2 as a pivot, recursively find the smallest free id within the two partition cells.

# but how?

def smallest_free_id5(array)
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
