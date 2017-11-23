# find the smallest index such that the fibonacci number at that index
# has a given number of digits

# ---------------------------------------------------------------------------
# with a loop
# ---------------------------------------------------------------------------

def find_fibonacci_index_by_length(number_of_digits)
  return 1 if number_of_digits == 1

  first = 1
  second = 1
  index = 2

  loop do
    index += 1
    fibonacci = first + second
    first = second
    second = fibonacci

    break if fibonacci.to_s.size >= number_of_digits
  end

  index
end

# ---------------------------------------------------------------------------
# with a loop that builds an array
# ---------------------------------------------------------------------------

def smallest_fibo(number_of_digits)
  return 0 if number_of_digits == 1

  f = []
  f[0] = 0
  f[1] = 1

  i = 2

  loop do
    f[i] = f[i - 1] + f[i - 2]
    break i if f[i].digits.count == number_of_digits
    i +=1
  end
end
