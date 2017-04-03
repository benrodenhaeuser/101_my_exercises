# write a method that computes the sum of two positive integers,
# without using the built-in `+` method.

# rubocop:disable Metrics/LineLength
SUM = {
  0  => { 0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9, 10 => 10 },
  1  => { 0 => 1, 1 => 2, 2 => 3, 3 => 4, 4 => 5, 5 => 6, 6 => 7, 7 => 8, 8 => 9, 9 => 10, 10 => 11 },
  2  => { 0 => 2, 1 => 3, 2 => 4, 3 => 5, 4 => 6, 5 => 7, 6 => 8, 7 => 9, 8 => 10, 9 => 11, 10 => 12 },
  3  => { 0 => 3, 1 => 4, 2 => 5, 3 => 6, 4 => 7, 5 => 8, 6 => 9, 7 => 10, 8 => 11, 9 => 12, 10 => 13 },
  4  => { 0 => 4, 1 => 5, 2 => 6, 3 => 7, 4 => 8, 5 => 9, 6 => 10, 7 => 11, 8 => 12, 9 => 13, 10 => 14 },
  5  => { 0 => 5, 1 => 6, 2 => 7, 3 => 8, 4 => 9, 5 => 10, 6 => 11, 7 => 12, 8 => 13, 9 => 14, 10 => 15 },
  6  => { 0 => 6, 1 => 7, 2 => 8, 3 => 9, 4 => 10, 5 => 11, 6 => 12, 7 => 13, 8 => 14, 9 => 15, 10 => 16 },
  7  => { 0 => 7, 1 => 8, 2 => 9, 3 => 10, 4 => 11, 5 => 12, 6 => 13, 7 => 14, 8 => 15, 9 => 16, 10 => 17 },
  8  => { 0 => 8, 1 => 9, 2 => 10, 3 => 11, 4 => 12, 5 => 13, 6 => 14, 7 => 15, 8 => 16, 9 => 17, 10 => 18 },
  9  => { 0 => 9, 1 => 10, 2 => 11, 3 => 12, 4 => 13, 5 => 14, 6 => 15, 7 => 16, 8 => 17, 9 => 18, 10 => 19 },
  10 => { 0 => 10, 1 => 11, 2 => 12, 3 => 13, 4 => 14, 5 => 15, 6 => 16, 7 => 17, 8 => 18, 9 => 19, 10 => 20 }
}
# rubocop:enable Metrics/LineLength

def convert_to_digits(number)
  number.to_s.split('').map(&:to_i)
end

def expand_to!(digits, max_number_of_digits)
  if digits.size < max_number_of_digits
    digits.unshift(0)
    expand_to!(digits, max_number_of_digits)
  end
end

def add(x, y)
  x_digits = convert_to_digits(x)
  y_digits = convert_to_digits(y)
  max_number_of_digits = [x_digits.size, y_digits.size].max
  expand_to!(x_digits, max_number_of_digits)
  expand_to!(y_digits, max_number_of_digits)
  carry = 0
  result = []

  while x_digits != []
    current_x = x_digits.pop
    current_y = y_digits.pop
    current_sum = SUM[SUM[carry][current_x]][current_y]
    if current_sum < 10
      result.unshift(current_sum)
      carry = 0
    else
      current_sum_digits = convert_to_digits(current_sum)
      result.unshift(current_sum_digits.last)
      carry = current_sum_digits.first
    end
  end

  result.unshift(carry)
  result.join.to_i
end

p add(1, 2) # 3
p add(8, 3) # 11
p add(10, 20) # 30
p add(15, 3) # 18
p add(1, 1000) # 1001
p add(10500, 456389) # 466889

100.times do
  x = rand(1..10000)
  y = rand(1..10000)
  p add(x,y)
end
