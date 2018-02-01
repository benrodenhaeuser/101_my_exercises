# reverse given array

# ----------------------------------------------------------------------------
# 01. non-destructive, iterative
# ----------------------------------------------------------------------------

def reverse(array)
  reversed = []
  counter = array.length - 1
  while counter >= 0
    reversed << array[counter]
    counter -= 1
  end
  reversed
end

# ----------------------------------------------------------------------------
# 02. non-destructive, recursive
# ----------------------------------------------------------------------------

def reverse_rec(array, counter = array.length - 1, reversed = [])
  return reversed if counter < 0
  reversed << array[counter]
  reverse_rec(array, counter - 1, reversed)
end

# ----------------------------------------------------------------------------
# 03. non-destructive, iterative, with splat
# ----------------------------------------------------------------------------

def reverse_with_splat(array)
  new_array = []
  array.size.times do
    *initial, last = array
    new_array << last
    array = initial
  end
  new_array
end

# ----------------------------------------------------------------------------
# 04. in-place, recursive
# ----------------------------------------------------------------------------

def reverse!(array, left = 0, right = array.size - 1)
  return array if left >= right
  array[left], array[right] = array[right], array[left]
  reverse!(array, left + 1, right - 1)
end

# ----------------------------------------------------------------------------
# 05. in-place, iterative
# ----------------------------------------------------------------------------

def reverse_iter!(array)
  left = 0
  right = array.size - 1
  while left < right
    array[left], array[right] = array[right], array[left]
    left += 1
    right -= 1
  end
  array
end

# ----------------------------------------------------------------------------
# tests
# ----------------------------------------------------------------------------

p reverse([]) == []
p reverse([1]) == [1]
p reverse([1, 2, 3, 4]) == [4, 3, 2, 1]

p reverse_rec([]) == []
p reverse_rec([1]) == [1]
p reverse_rec([1, 2, 3, 4]) == [4, 3, 2, 1]

p reverse_with_splat([]) == []
p reverse_with_splat([1]) == [1]
p reverse_with_splat([1, 2, 3, 4]) == [4, 3, 2, 1]

p reverse!([]) == []
p reverse!([1]) == [1]
p reverse!([1, 2, 3, 4]) == [4, 3, 2, 1]

p reverse_iter!([]) == []
p reverse_iter!([1]) == [1]
p reverse_iter!([1, 2, 3, 4]) == [4, 3, 2, 1]
