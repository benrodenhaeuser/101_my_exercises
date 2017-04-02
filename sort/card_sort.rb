# sorting to a new array by insertion

# like you would sort a deck of cards:
# - the input `array` = "the unsorted cards in your right hand"
# - move cards from you right hand to your left hand, preserving the property
#   that the cards in your right hand are sorted (our loop invariant)

# ... pretty complicated!

# sort given array
def sort(array)
  sorted = []
  for index in (0...array.size)
    sorted = order_insert(array[index], sorted)
  end
  sorted
end

# insert value in ordered array, returning an order
def order_insert(value, order)
  return [value] if order == []
  # ^ edge case; won't happen if we call from sort
  index = 0
  loop do
    if value <= order[index]
      order = insert_at(index, value, order)
      break
    end
    index += 1
    if index == order.size
      order[index] = value
      break
    end
  end
  order
end

# insert value `value` in array `array` at index `index`
def insert_at(index, value, array)
  return nil if index > array.size
  # ^ edge case; won't happen if we call from insert
  breakpoint = array.size + 1
  value_to_insert = value
  loop do
    value_stored = array[index]
    array[index] = value_to_insert
    value_to_insert = value_stored
    index += 1
    break if index == breakpoint
  end
  array
end

p sort([10, 5, 3, 0]) # [0, 3, 5, 10]
p sort([]) # []
p sort([1, 3, 10, 4]) # [1, 3, 4, 10]
p sort([1, 1, 1, 1, 1]) # [1, 1, 1, 1, 1]
