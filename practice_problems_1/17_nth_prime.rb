# Write a method that returns the `n`th prime number. Recall that only
# numbers greater than 1 can be prime.
#
# Difficulty: medium.

=begin

given a natural number n

local variable `number` (=> the natural number whose primeness is under investigation) — initialize to 2
local variable `counter` (=> the number of primes found so far) - initialize to 0

loop

    increment counter by 1 if number is prime (=> use is_prime?)
    break number if counter == n

    increment number by 1
end of loop

sanity check:
- suppose we are looking for the first prime number
- initially, number is 2
- 2 is prime, so counter will be incremented by 1.
- counter now equals 1
- we are looking for first prime number, so our n is 1, so counter == n
- we break out of the loop
- we implicitly return number which is 2

what if people call nth_prime with integers smaller 1?

=end


# solution

def nth_prime(n)
  return nil if n < 1

  number = 2
  counter = 0
  loop do
    counter += 1 if is_prime?(number)
    break number if counter == n
    number += 1
  end
end

def is_prime?(number)
  (2..number - 1).each do |other_number|
    return false if number % other_number == 0
  end
  true
end


# solution with `while` instead of `loop`

# requires keeping track of current number and counter in a slightly different way

def nth_prime(n)
  return nil if n < 1

  number = 1
  counter = 0

  while counter < n
    number += 1
    counter += 1 if is_prime?(number)
  end

  number
end


puts("\nTests for #nth_prime")
puts("===============================================")
    puts('nth_prime(1) == 2: ' + (nth_prime(1) == 2).to_s)
    puts('nth_prime(2) == 3: ' + (nth_prime(2) == 3).to_s)
    puts('nth_prime(3) == 5: ' + (nth_prime(3) == 5).to_s)
    puts('nth_prime(4) == 7: ' + (nth_prime(4) == 7).to_s)
    puts('nth_prime(5) == 11: ' + (nth_prime(5) == 11).to_s)
puts("===============================================")
