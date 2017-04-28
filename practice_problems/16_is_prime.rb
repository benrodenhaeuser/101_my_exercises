# Write a method that takes in an integer (greater than one) and
# returns true if it is prime; otherwise return false.
#
# You may want to use the `%` modulo operation. `5 % 2` returns the
# remainder when dividing 5 by 2; therefore, `5 % 2 == 1`. In the case
# of `6 % 2`, since 2 evenly divides 6 with no remainder, `6 % 2 == 0`.
# More generally, if `m` and `n` are integers, `m % n == 0` if and only
# if `n` divides `m` evenly.
#
# You would not be expected to already know about modulo for the
# challenge.
#
# Difficulty: medium.

=begin

APPROACH:

given a number ('number')
expected return: yes if number prime, no otherwise

algo (rough):

- step 1:
  for every 1 < other_number < number: return false if number % other_number == 0
- step 2:
  return true
  (=> Because if we reached step 2, the number is prime)

a bit of detail for step 1:

- We are dealing with a range: (2..number - 1) (these are the numbers we need to check)
- So we can iterate over the range with each and apply the "return recipe" given above

=end


def is_prime?(number)
  (2..number - 1).each do |other_number|
    return false if number % other_number == 0
  end
  true
end

# These are tests to check that your code is working. After writing
# your solution, they should all print true.

puts("\nTests for #is_prime?")
puts("===============================================")
    puts('is_prime?(2) == true: ' + (is_prime?(2) == true).to_s)
    puts('is_prime?(3) == true: ' + (is_prime?(3) == true).to_s)
    puts('is_prime?(4) == false: ' + (is_prime?(4) == false).to_s)
    puts('is_prime?(9) == false: ' + (is_prime?(9) == false).to_s)
puts("===============================================")
