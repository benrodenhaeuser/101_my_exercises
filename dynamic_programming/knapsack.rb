# Given n items of known weights w1, w2, ..., wn and values v1, v2, ..., vn and a knapsack of capacity W, find the maximum value you can obtain by putting a selection of items into the knapsack.

# -----------------------------------------------------------------------------
# background
# -----------------------------------------------------------------------------

=begin

we are looking for a recurrence knapsack(capacity, index), where size is the size of the knapsack, and index is the index of the current item in some list.

to make the algorithm easier to express, we put in a dummy item at the beginning of the item list, which weighs nothing and has no value.

two base cases:
(1) 0th item ==> value is 0
(2) no capacity ==> value is 0

recursive case:
we are considering a knapsack of some capacity > 0 and an item which is not
at the beginning of the list of items
there are two options:
(1) current item goes into the knapsack
(2) current item does not go into the knapsack

in case (1), the optimal value we can achieve is
   knapsack(capacity, index - 1)
in case (2), the optimal value we can achieve is
   value_of(index) + knapsack(capacity - weight(index), index - 1)
so we take the maximum of those two values.

=end

# ----------------------------------------------------------------------------
# implementing the recurrence
# ----------------------------------------------------------------------------

# the implementation uses a (weight- and valueless) dummy item prepended to the
# list of items.

ITEMS = [[0, 0], [1500, 1], [2000, 3], [3000, 4], [2000, 1]]

def value_of(index)
  ITEMS[index].first
end

def weight_of(index)
  ITEMS[index].last
end

def knapsack(capacity, index = ITEMS.size - 1)

  if capacity == 0 || index == 0
    0

  elsif weight_of(index) > capacity
    knapsack(capacity, index - 1)

  else
    [
      knapsack(capacity, index - 1),
      value_of(index) + knapsack(capacity - weight_of(index), index - 1)
    ].max
  end

end

# call the method passing a capacity
p knapsack(4) # returned value: 4000 (correct)

# ----------------------------------------------------------------------------
# dynamic programming solution with tabulation
# ----------------------------------------------------------------------------

# instead of (top-down) recursive calls knapsack(capacity, index), we have to
# build a table knapsack[capacity, item] bottom-up.

# TODO
