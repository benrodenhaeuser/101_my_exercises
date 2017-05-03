# Write a method that takes an array of numbers. If a pair of numbers
# in the array sums to zero, return the positions of those two numbers.
# If no pair of numbers sums to zero, return `nil`.
#
#
#
#
# Difficulty: medium.


# with each

def two_sum(nums)
  nums.each_with_index do |num1, idx1|
    nums.each_with_index do |num2, idx2|
      return [idx1, idx2] if (num1 != num2 && num1.abs == num2.abs)
    end
  end
  nil
end

# with a double loop

def two_sums(nums)
  idx1 = 0
  loop do
    break if idx1 == nums.size
    idx2 = 0
    loop do
      break if idx2 == nums.size
      return [idx1, idx2] if (nums[idx1] != nums[idx2] && nums[idx1].abs == nums[idx2].abs)
      idx2 += 1
    end
    idx1 += 1
  end
  nil
end


puts("\nTests for #two_sum")
puts("===============================================")
    puts(
      'two_sum([1, 3, 5, -3]) == [1, 3]: ' + (two_sum([1, 3, 5, -3]) == [1, 3]).to_s
    )
    puts(
      'two_sum([1, 3, 5]) == nil: ' + (two_sum([1, 3, 5]) == nil).to_s
    )
puts("===============================================")
