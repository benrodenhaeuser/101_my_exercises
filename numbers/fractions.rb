# calculations with fractions
# approach: represent fractions as two-element arrays

# adding two fractions
def add_frac(frac1, frac2)
  numerator1 = frac1[0]
  numerator2 = frac2[0]
  denominator1 = frac1[1]
  denominator2 = frac2[1]

  if denominator1 == denominator2
    [numerator1 + numerator2, denominator1]
  else
    [numerator1 * denominator2 + numerator2 * denominator1, denominator1 * denominator2]
  end
end

def greatest_common_divisor(number1, number2)
  if number2 == 0
    number1
  else
    greatest_common_divisor(number2, number1 % number2)
  end
end

# reducing a fraction
def reduce(frac)
  numerator = frac[0]
  denominator = frac[1]
  gcd = greatest_common_divisor(numerator,denominator)
  [numerator/gcd, denominator/gcd]
end

# representing fractions
def frac(number1, number2)
  [number1, number2]
end

p reduce(frac(4, 4))
