# Write a function, `nearest_larger(arr, i)` which takes an array and an
# index.  The function should return another index, `j`: this should
# satisfy:
#
# (a) `arr[i] < arr[j]`, AND
# (b) there is no `j2` closer to `i` than `j` where `arr[i] < arr[j2]`.
#
# In case of ties (see example below), choose the earliest (left-most)
# of the two indices. If no number in `arr` is larger than `arr[i]`,
# return `nil`.
#
# Difficulty: 2/5

=begin

approach

REQUIREMENTS

- given array `array` and integer `number1`
- find integer `number2` such that array[number1] is smaller than array[number2]
- there is no number3 closer to number1 satisfying that array[number1] is smaller than array[number3]
- if no larger number than number1 can be found in array, return nil

EXAMPLE:

array is [2, 3, 4, 8]
index 2
array[2] is 4
need to find larger element, as close as possible => 8
index of 8 is 3, i.e., array[3] = 8
return 8

array is [2, 8 , 4, 3]
index is 2
array[2] is 4
need to find larger element, as close as possible ==> 8
index of 8 is 1, i.e., array[1] = 8

ALGO:

- given number and index
- two search_indices a and b, initially a = index - 1, b = index + 1
- loop
  - return nil if both a and b are out of bounds
  - if array[a] is (not nil and) larger than array[index], return array[a]
  - elsif array[b] is (not nil and) larger than array[index], return array[b]
  - else a -=1, b += 1


=end

# my solution:

def nearest_larger(array, index)
  left = index - 1
  right = index + 1
  loop do
    if left > -1
      return left if array[left] > array[index]
      left -= 1
    elsif right < array.length
      return right if array[right] > array[index]
      right += 1
    else # both left and right are out of bounds
      return nil
    end
  end
end

# instructor solution:

def nearest_larger(arr, idx)
  diff = 1
  while true
    left = idx - diff
    right = idx + diff

    if (left >= 0) && (arr[left] > arr[idx])
      return left
    elsif (right < arr.length) && (arr[right] > arr[idx])
      return right
    elsif (left < 0) && (right >= arr.length)
      return nil
    end

    diff += 1
  end
end


puts("Tests for #nearest_larger")
puts("===============================================")
    puts "nearest_larger([2,3,4,8], 2) == 3: "  + (nearest_larger([2,3,4,8], 2) == 3).to_s
    puts "nearest_larger([2,8,4,3], 2) == 1: "  + (nearest_larger([2,8,4,3], 2) == 1).to_s
    puts "nearest_larger([2,6,4,8], 2) == 1: "  + (nearest_larger([2,6,4,8], 2) == 1).to_s
    puts "nearest_larger([2,6,4,6], 2) == 1: "  + (nearest_larger([2,6,4,6], 2) == 1).to_s
    puts "nearest_larger([8,2,4,3], 2) == 0: "  + (nearest_larger([8,2,4,3], 2) == 0).to_s
    puts "nearest_larger([2,4,3,8], 1) == 3: "  + (nearest_larger([2,4,3,8], 1) == 3).to_s
    puts "nearest_larger([2, 6, 4, 8], 3) == nil: "+ (nearest_larger([2, 6, 4, 8], 3) == nil).to_s
    puts "nearest_larger([2, 6, 9, 4, 8], 3) == 2: "+ (nearest_larger([2, 6, 9, 4, 8], 3) == 2).to_s
puts("===============================================")
