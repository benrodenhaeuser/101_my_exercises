# find the smallest index such that the fibonacci number at that index
# has a given number of digits

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

p find_fibonacci_index_by_length(2) == 7
p find_fibonacci_index_by_length(10) == 45
p find_fibonacci_index_by_length(100) == 476
p find_fibonacci_index_by_length(1000) == 4782
p find_fibonacci_index_by_length(10000) == 47847 # this takes a bit
