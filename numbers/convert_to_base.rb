# convert a decimal number to representation in base up to 10

def convert_to_base(base, number)
  digits = []

  while number != 0
    digits.unshift(number % base)
    number = number / base
  end

  digits.join
end

p convert_to_base(2, 8) # '1000'
p convert_to_base(3, 8) # '22'
