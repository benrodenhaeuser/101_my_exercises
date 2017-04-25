=begin

Given an integer `product`, find the *smallest positive integer* the product of
whose digits is equal to product. If there is no such integer, return -1 instead.

Input/Output:
[input] integer `product`
Constraints: 0 ≤ product ≤ 600.
[output] a positive integer

=end

# my solution

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


# Jerome's solution
def digits_product(product)
    return 11 if product == 1
    return 10 if product == 0
  factors = (2..9).select { |n| product % n == 0 }
  result = []
  [2, 3, 5, 7].each do |prime|
    loop do
      product % prime == 0 ? product / prime : break
      product /= prime
      result << prime
    end
  end
  return -1 if product != 1
  while result.count(2) >= 3
    result = result[3..-1] << 8
  end
  while result.count(3) >= 2
      [3, 3].each do |n|
        result.delete_at(result.find_index { |e| e == n })
    end
    result << 9
  end
  while result.count(2) >= 1 && result.include?(2) && result.include?(3)
      [2, 3].each do |n|
        result.delete_at(result.find_index { |e| e == n })
    end
    result << 6
  end
  while result.count(2) >= 2
      [2, 2].each do |n|
        result.delete_at(result.find_index { |e| e == n })
    end
    result << 4
  end

  result << 1 if result.size == 1
  result.sort.map(&:to_s).join.to_i
end

p digits_product(1) == 11 # ok
p digits_product(10) == 25 # ok
p digits_product(12) == 26 # ok
p digits_product(19) == -1 # ok
p digits_product(450) == 2559 # ok
p digits_product(581) == -1 # ok
