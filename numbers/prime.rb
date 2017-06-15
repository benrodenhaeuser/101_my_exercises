# write a method to determine whether a number is a prime

=begin
IO:
number/boolean

analysis/definitions:
a prime number is a number that has not other divisors than itself and 1

algo:
iterate over range (2..number -1) |num2|
check whether number is divisible by num2

if the answer is true for some num2, then number is not prime

==> way to check divisibility: use %
number1 is divisible by number2 iff number1 & number2 == 0

==> iterator to use: Enumerable#any? (plus negation)

=end

def prime?(number)
  !(2..number - 1).any? { |number2| number % number2 == 0 }
end

p prime?(10)
p prime?(7)
