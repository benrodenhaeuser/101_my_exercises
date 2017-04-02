def binary_search(value, order)
  lower_bound = 0
  upper_bound = order.size - 1
  while upper_bound >= lower_bound
    midpoint = (upper_bound + lower_bound) / 2
    value_at_midpoint = order[midpoint]
    if value_at_midpoint > value # have to look to the left
      upper_bound = midpoint - 1
    elsif value_at_midpoint < value # have to look to the right
      lower_bound = midpoint + 1
    elsif value_at_midpoint == value
      return value
    end
  end
  nil
end

arr = [0, 1, 2, 3, 4, 5, 6, 7]

for i in arr
  p binary_search(i, arr) # 0 1 2 3 4 5  6 7
end

p binary_search(100, arr) # nil
