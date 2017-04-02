def binary_search(number, order)
  lower_bound = 0
  upper_bound = order.size - 1
  loop do
    midpoint = (lower_bound + upper_bound) / 2
    value_at_midpoint = order[midpoint]
    if value_at_midpoint == number
      return midpoint
    elsif value_at_midpoint > number # right half is higher
      upper_bound = midpoint - 1
    elsif value_at_midpoint < number # left half is lower
      lower_bound = midpoint + 1
    end
    break if lower_bound > upper_bound
  end
end

arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

for number in arr
  p binary_search(number, arr)
end
