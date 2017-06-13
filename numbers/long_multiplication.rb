# long multiplication and addition in decimal and binary, using the standard grade-school algorithms.

SUM_TABLE =
  {
    '2' =>
      {
        '0' => { '0' => '0', '1' => '1' },
        '1' => { '0' => '1', '1' => '10' },
        '10' => { '0' => '10', '1' => '11' }
      },
    '10' =>
      {
        '0'  => { '0' => '0', '1' => '1', '2' => '2', '3' => '3', '4' => '4', '5' => '5', '6' => '6', '7' => '7', '8' => '8', '9' => '9', '10' => '10' },
        '1'  => { '0' => '1', '1' => '2', '2' => '3', '3' => '4', '4' => '5', '5' => '6', '6' => '7', '7' => '8', '8' => '9', '9' => '10', '10' => '11' },
        '2'  => { '0' => '2', '1' => '3', '2' => '4', '3' => '5', '4' => '6', '5' => '7', '6' => '8', '7' => '9', '8' => '10', '9' => '11', '10' => '12' },
        '3'  => { '0' => '3', '1' => '4', '2' => '5', '3' => '6', '4' => '7', '5' => '8', '6' => '9', '7' => '10', '8' => '11', '9' => '12', '10' => '13' },
        '4'  => { '0' => '4', '1' => '5', '2' => '6', '3' => '7', '4' => '8', '5' => '9', '6' => '10', '7' => '11', '8' => '12', '9' => '13', '10' => '14' },
        '5'  => { '0' => '5', '1' => '6', '2' => '7', '3' => '8', '4' => '9', '5' => '10', '6' => '11', '7' => '12', '8' => '13', '9' => '14', '10' => '15' },
        '6'  => { '0' => '6', '1' => '7', '2' => '8', '3' => '9', '4' => '10', '5' => '11', '6' => '12', '7' => '13', '8' => '14', '9' => '15', '10' => '16' },
        '7'  => { '0' => '7', '1' => '8', '2' => '9', '3' => '10', '4' => '11', '5' => '12', '6' => '13', '7' => '14', '8' => '15', '9' => '16', '10' => '17' },
        '8'  => { '0' => '8', '1' => '9', '2' => '10', '3' => '11', '4' => '12', '5' => '13', '6' => '14', '7' => '15', '8' => '16', '9' => '17', '10' => '18' },
        '9'  => { '0' => '9', '1' => '10', '2' => '11', '3' => '12', '4' => '13', '5' => '14', '6' => '15', '7' => '16', '8' => '17', '9' => '18', '10' => '19' },
        '10' => { '0' => '10', '1' => '11', '2' => '12', '3' => '13', '4' => '14', '5' => '15', '6' => '16', '7' => '17', '8' => '18', '9' => '19', '10' => '20' }
      }
  }

PRODUCT_TABLE =
  {
    '2' =>
      {
        '0' => { '0' => '0', '1' => '0' },
        '1' => { '0' => '0', '1' => '1' },
      },
    '10' =>
      {
        '0' => { '0' => '0', '1' => '0', '2' => '0', '3' => '0', '4' => '0', '5' => '0', '6' => '0', '7' => '0', '8' => '0', '9' => '0' },
        '1' => { '0' => '0', '1' => '1', '2' => '2', '3' => '3', '4' => '4', '5' => '5', '6' => '6', '7'=> '7', '8' => '8', '9' => '9' },
        '2' => { '0' => '0', '1' => '2', '2' => '4', '3' => '6', '4' => '8', '5' => '10', '6' => '12', '7' => '14', '8' => '16', '9' => '18' },
        '3' => { '0' => '0', '1' => '3', '2' => '6', '3' => '9', '4' => '12', '5' => '15', '6' => '18', '7' => '21', '8' => '24', '9' => '27' },
        '4' => { '0' => '0', '1' => '4', '2' => '8', '3' => '12', '4' => '16', '5' => '20', '6' => '24', '7' => '28', '8' => '32', '9' => '36' },
        '5' => { '0' => '0', '1' => '5', '2' => '10', '3' => '15', '4' => '20', '5' => '25', '6' => '30', '7' => '35', '8' => '40', '9' => '45' },
        '6' => { '0' => '0', '1' => '6', '2' => '12', '3' => '18', '4' => '24', '5' => '30', '6' => '36', '7' => '42', '8' => '48', '9' => '54' },
        '7' => { '0' => '0', '1' => '7', '2' => '14', '3' => '21', '4' => '28', '5' => '35', '6' => '42', '7' => '49', '8' => '56', '9' => '63' },
        '8' => { '0' => '0', '1' => '8', '2' => '16', '3' => '24', '4' => '32', '5' => '40', '6' => '48', '7' => '56', '8' => '64', '9' => '72' },
        '9' => { '0' => '0', '1' => '9', '2' => '18', '3' => '27', '4' => '36', '5' => '45', '6' => '54', '7' => '63', '8' => '72', '9' => '81'}
      }
  }

# multiplication

def multiply(x, y, base = '10')
  summands = []

  x_digits = digits(x)
  y_digits = digits(y)
  position_counter = 0

  while y_digits != []
    current_y_digit = y_digits.pop
    summands <<
      multiply_by_digit(x_digits, current_y_digit, position_counter, base).join
    position_counter += 1
  end

  sum_up(summands, base)
end

def multiply_by_digit(digits, digit, position_counter, base)
  result = []

  index = digits.size - 1
  carry = '0'

  while index >= 0
    current_multiple = add(PRODUCT_TABLE[base][digits[index]][digit], carry, base)
    if current_multiple.length == 1
      result.unshift(current_multiple)
      carry = '0'
    else
      result.unshift(digits(current_multiple).last)
      carry = digits(current_multiple).first
    end
    index -= 1
  end

  result.unshift(carry) unless carry == '0'
  position_counter.times { result.push('0') }

  result
end

def sum_up(list_of_numbers, base)
  result = list_of_numbers.pop

  while list_of_numbers != []
    result = add(result, list_of_numbers.pop, base)
  end

  result
end

# addition

def add(x, y, base = '10')
  result = []

  x_digits = digits(x)
  y_digits = digits(y)
  expand_to_same_length!(x_digits, y_digits)
  carry = '0'

  while x_digits != []
    current_x_digit = x_digits.pop
    current_y_digit = y_digits.pop

    current_x_digit_plus_carry = SUM_TABLE[base][carry][current_x_digit]
    current_sum =
      SUM_TABLE[base][current_x_digit_plus_carry][current_y_digit]

    if current_sum.size == 1
      result.unshift(current_sum)
      carry = '0'
    else
      result.unshift(digits(current_sum).last)
      carry = digits(current_sum).first
    end
  end

  result.unshift(carry) unless carry == '0'
  result.join
end

def digits(string)
 string.chars
end

def expand_to_same_length!(digits1, digits2)
  target_length = [digits1.size, digits2.size].max
  expand_to!(target_length, digits1)
  expand_to!(target_length, digits2)
end

def expand_to!(length, digits)
  if digits.size < length
    digits.unshift('0')
    expand_to!(length, digits)
  end
end

# tests

def test_for_decimal(number_of_tests)
  passed = true

  number_of_tests.times do
    x = rand(1..1000)
    y = rand(1..1000)
    product = x * y
    product = product.to_s

    x_string = x.to_s
    y_string = y.to_s
    my_product = multiply(x_string, y_string)

    passed = false if product != my_product
  end

  puts 'passed test for decimal' if passed
end

def test_for_binary(number_of_tests)
  passed = true

  number_of_tests.times do
    x = rand(1..1000)
    y = rand(1..1000)
    product = x * y
    product = product.to_s(2)

    x_string = x.to_s(2)
    y_string = y.to_s(2)
    my_product = multiply(x_string, y_string, '2')

    passed = false if product != my_product
  end

  puts 'passed test for binary' if passed
end

test_for_decimal(1000)
test_for_binary(1000)
