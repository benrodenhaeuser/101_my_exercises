# Write a method that takes in two numbers. Return the greatest
# integer that evenly divides both numbers. You may wish to use the
# `%` modulo operation.
#
# Difficulty: medium.

def greatest_common_divisor(number1, number2)
end




# These are tests to check that your code is working. After writing
# your solution, they should all print true.

puts("\nTests for #greatest_commmon_divisor")
puts("===============================================")
    puts(
      'greatest_common_divisor(3, 9) == 3: ' +
      (greatest_common_divisor(3, 9) == 3).to_s
    )
    puts(
      'greatest_common_divisor(16, 24) == 8: ' +
      (greatest_common_divisor(16, 24) == 8).to_s
    )
    puts(
      'greatest_common_divisor(3, 5) == 1: ' +
      (greatest_common_divisor(3, 5) == 1).to_s
    )
puts("===============================================")
