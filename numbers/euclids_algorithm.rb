# euclid's algorithm to determine the greatest common divisors of two integers
# https://en.wikipedia.org/wiki/Euclidean_algorithm

# recursive solution with subtraction
def greatest_common_divisor_rec_sub(number1, number2)
  if number1 == number2
    number1
  elsif number1 > number2
    greatest_common_divisor_rec_sub(number1 - number2, number2)
  else
    greatest_common_divisor_rec_sub(number1, number2 - number1)
  end
end

# recursive solution with mod
def greatest_common_divisor_rec_mod(number1, number2)
  if number2 == 0
    number1
  else
    greatest_common_divisor_rec_mod(number2, number1 % number2)
  end
end

# iterative solution with mod
def greatest_common_divisor_it_mod(number1, number2)
  while number2 != 0
    stored = number1
    number1 = number2
    number2 = stored % number2
  end
  number1
end

p greatest_common_divisor_it_mod(4, 4) == 4
p greatest_common_divisor_it_mod(6, 4) == 2
p greatest_common_divisor_it_mod(9, 3) == 3
p greatest_common_divisor_it_mod(27, 3) == 3
p greatest_common_divisor_it_mod(27, 9) == 9

puts

p greatest_common_divisor_rec_mod(4, 4) == 4
p greatest_common_divisor_rec_mod(6, 4) == 2
p greatest_common_divisor_rec_mod(9, 3) == 3
p greatest_common_divisor_rec_mod(27, 3) == 3
p greatest_common_divisor_rec_mod(27, 9) == 9

puts

p greatest_common_divisor_rec_sub(4, 4) == 4
p greatest_common_divisor_rec_sub(6, 4) == 2
p greatest_common_divisor_rec_sub(9, 3) == 3
p greatest_common_divisor_rec_sub(27, 3) == 3
p greatest_common_divisor_rec_sub(27, 9) == 9
