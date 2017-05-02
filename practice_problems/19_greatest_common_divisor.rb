# Write a method that takes in two numbers. Return the greatest
# integer that evenly divides both numbers. You may wish to use the
# `%` modulo operation.
#
# Difficulty: medium.

=begin

Approach

to determine the greatest common divisor of two numbers:

- if number1 == number2, then their gcd is number1
- elsif number1 > number2, then their gcd is gcd(number1 - number2, number1)
- else their gcd is (number1, number2 - number1)

will this work?

example: 60 and 40

gcd(60, 40) = gcd(60 - 40, 40) = gcd(20, 40) = gcd(20, 40 - 20) = gcd(20, 20) = 20

so for 60 and 40, this works just fine.

=end

def greatest_common_divisor(number1, number2)
  if number1 == number2
    number1
  elsif number1 > number2
    greatest_common_divisor(number1 - number2, number2)
  else
    greatest_common_divisor(number1, number2 - number1)
  end
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
