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

array = [18, 4, 8, 9, 16, 1, 14, 7, 19, 3, 0, 5, 2, 11, 6]
p smallest_free_id1(array) # => 10

# ----------------------------------------------------------------------------
# solution 2: sort and check
# ----------------------------------------------------------------------------

def smallest_free_id2(array)
  array.sort.each_with_index do |value, index|
    return index unless index == value
  end
end

array = [18, 4, 8, 9, 16, 1, 14, 7, 19, 3, 0, 5, 2, 11, 6]
p smallest_free_id2(array) # => 10

# ----------------------------------------------------------------------------
# solution 2: recording observations
# ----------------------------------------------------------------------------

# we set up an extra array `gaps` that records what we see as we walk through the array of ids. we delete every element we encounter from `gaps`. whatever remains in `gaps` after walking through the array is a gap. since `gaps` is sorted, `gaps.first` is the smallest gap, so it is the smallest free id.

def smallest_free_id3(array)
  gaps = (0...array.size).to_a
  array.each do |value|
    gaps.delete(value) if value < array.size
  end
  gaps.first
end

array = [18, 4, 8, 9, 16, 1, 14, 7, 19, 3, 0, 5, 2, 11, 6]
p smallest_free_id3(array) # => 10
