# Write a method that takes an array of numbers in. Your method should
# return the third greatest number in the array. You may assume that
# the array has at least three numbers in it.
#
# Difficulty: medium.

=begin

APPROACH

here is how we could do it (still very roughly):
- find the largest number and remove it from array
- find the largest number in remaining (!) array and remove it
- again find largest in remaining and RETURN it

now this sounds a lot like a destructive method, but let's give it a shot anyway.

OK, now for a non-destructive solution.

The logic seems ok. Is there a way to "reassign" nums to "nums - largest"

Yes. We can do it via select.

Now what if we did not know about select? What if we had to do it with some kind of loop?

=end

# destructive solution

def third_greatest(nums)

  2.times do
    largest = nums.max
    nums.delete(largest)
  end

  return nums.max

end

# non-destructive solution

def third_greatest(nums)

  2.times do
    largest = nums.max
    nums = nums.select { |num| num < largest }
  end

  return nums.max

end

# non-destructive solution without fancy select

def third_greatest(nums)

  2.times do
    largest = nums.max
    without_largest = []
    index = 0
    loop do
      without_largest << nums[index] if nums[index] < largest
      index += 1
      break if index == nums.count
    end
    nums = without_largest
  end

  return nums.max

end




# These are tests to check that your code is working. After writing
# your solution, they should all print true.

puts("\nTests for #third_greatest")
puts("===============================================")
    puts(
      'third_greatest([5, 3, 7]) == 3: ' +
      (third_greatest([5, 3, 7]) == 3).to_s
    )
    puts(
      'third_greatest([5, 3, 7, 4]) == 4: ' +
      (third_greatest([5, 3, 7, 4]) == 4).to_s
    )
    puts(
      'third_greatest([2, 3, 7, 4]) == 3: ' +
      (third_greatest([2, 3, 7, 4]) == 3).to_s
    )
puts("===============================================")
