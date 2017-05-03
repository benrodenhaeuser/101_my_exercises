# Write a method that takes in an integer `num` and returns the sum of
# all integers between zero and num, up to and including `num`.
#
# Difficulty: easy.

# with inject

def sum_nums(num)
  (1..num).inject(&:+)
end

# with each

def sum_nums(num)
  sum = 0
  (1..num).each { |current_number| sum += current_number  }
  sum
end

# with a loop

def sum_nums(num)
  sum = 0
  current_number = 0
  loop do
    break if current_number > num
    sum += current_number
    current_number += 1
  end
  sum
end


puts("\nTests for #sum_nums")
puts("===============================================")
    puts('sum_nums(1) == 1: ' + (sum_nums(1) == 1).to_s)
    puts('sum_nums(2) == 3: ' + (sum_nums(2) == 3).to_s)
    puts('sum_nums(3) == 6: ' + (sum_nums(3) == 6).to_s)
    puts('sum_nums(4) == 10: ' + (sum_nums(4) == 10).to_s)
    puts('sum_nums(5) == 15: ' + (sum_nums(5) == 15).to_s)
puts("===============================================")
