# There is a row of n coins whose values are some positive integers
# c1, c2, ..., cn, not necessarily distinct. The goal is to pick up the maximum
# amount of money subject to the constraint that no two coins adjacent in the
# initial row can be picked up.

# (Levitin, p. 285)

# Approach:
# How can we express the solution for n in terms of smaller solutions? The
# max_amount for n will either include the coin at position n, or not. In the
# first case, max_amount(n) is val(n) + max_amount(n - 2), because the coin at
# n - 1 cannot be picked. In the second case, max_amount(n) is max_amount(n -
# 1), the coin at n is irrelevant, so to speak.

# ----------------------------------------------------------------------------
# 1. "naive" solution
# ----------------------------------------------------------------------------

def max_amount(array_of_coins)
  case array_of_coins.length
  when 0 then 0
  when 1 then array_of_coins.first
  when 2 then [array_of_coins.first, array_of_coins.last].max
  else
    [
      array_of_coins.last + max_amount(array_of_coins[0..-3]),
      max_amount(array_of_coins[0..-2])
    ].max
  end
end

p max_amount([4, 2, 3, 5]) # 9
p max_amount([4, 2, 3, 5, 10]) # 17
p max_amount([5, 1, 2, 10, 6, 2]) # 17

# ----------------------------------------------------------------------------
# 2. memoization
# ----------------------------------------------------------------------------

def max_amount_memo(array_of_coins, max_amounts = {})
  return max_amounts[array_of_coins] if max_amounts[array_of_coins]

  case array_of_coins.length
  when 0 then 0
  when 1
    max_amounts[array_of_coins] = array_of_coins.first
  when 2
    max_amounts[array_of_coins] = [
      array_of_coins.first, array_of_coins.last
    ].max
  else
    max_amounts[array_of_coins] = [
      array_of_coins.last + max_amount_memo(array_of_coins[0..-3]),
      max_amount_memo(array_of_coins[0..-2])
    ].max
  end
end

p max_amount_memo([4, 2, 3, 5]) # 9
p max_amount_memo([4, 2, 3, 5, 10]) # 17
p max_amount_memo([5, 1, 2, 10, 6, 2]) # 17

# ----------------------------------------------------------------------------
# 3. tabulation
# ----------------------------------------------------------------------------

def max_amount_tabu(array_of_coins)
  return 0 if array_of_coins.empty?

  max_table = []
  max_table[0] = array_of_coins[0]
  max_table[1] = [array_of_coins[0], array_of_coins[1]].max

  n = 2 # index to access elements of array_of_coins
  while n < array_of_coins.length
    max_table[n] = [
      array_of_coins[n] + max_table[n - 2], max_table[n - 1]
    ].max
    n += 1
  end

  max_table.last
end

p max_amount_tabu([4, 2, 3, 5]) # 9
p max_amount_tabu([4, 2, 3, 5, 10]) # 17
p max_amount_tabu([5, 1, 2, 10, 6, 2]) # 17
