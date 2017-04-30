=begin

Given an integer `product`, find the *smallest positive integer* the product of
whose digits is equal to product. If there is no such integer, return -1 instead.

Input/Output:
[input] integer `product`
Constraints: 0 ≤ product ≤ 600.
[output] a positive integer

=end

def factors(number)
  divisors = (2..9).to_a.reverse.select { |n| number % n == 0 }.to_a
  factor = divisors.first unless divisors.empty?

  if divisors.empty?
    [number]
  elsif (number / factor) % 10 == number / factor
    [factor, number / factor]
  else
    [factor, factors(number / factor)].flatten
  end
end

def digits_product(number)
  if number < 10
    ('1' + number.to_s).to_i
  else
    factors = factors(number)
    if factors.all? { |factor| factor % 10 == factor }
      factors.reverse.join.to_i
    else
      -1
    end
  end
end

# tests
p digits_product(0) == 10 # ok
p digits_product(1) == 11 # ok
p digits_product(10) == 25 # ok
p digits_product(12) == 26 # ok
p digits_product(19) == -1 # ok
p digits_product(450) == 2559 # ok
p digits_product(581) == -1 # ok
