# Give change for amount n using the minimum number of coins of given denominations d1, d2, ..., dm. You may assume that the given denominations will include a penny, i.e., a coin with value 1.

# We are here looking to find not the minimum number of coins, but a list of coins which sums up to n which is minimal in length.

DENOMINATIONS = [1, 3, 5, 4, 6, 9, 1, 3]

# ----------------------------------------------------------------------------
# "naive" solution
# ----------------------------------------------------------------------------

def change(n)
  return [] if n == 0
  return [1] if n == 1 # recall that we have pennies

  change = (1..n).map { 1 } # "worst case"
  for den in DENOMINATIONS.select { |value| value <= n }
    change = [change, change(n - den) + [den]].min_by { |list| list.size }
  end
  change
end

# ----------------------------------------------------------------------------
# tabulation
# ----------------------------------------------------------------------------

def change_tabu(amount)

  table = []

  table[0] = []
  table[1] = [1]

  n = 2

  while n <= amount
    change = (1..n).map { 1 }
    for den in DENOMINATIONS.select { |value| value <= n }
      change = [change, table[n - den] + [den]].min_by { |list| list.size }
    end
    table[n] = change
    n += 1
  end

  return table[amount]
end

# ----------------------------------------------------------------------------
# tests
# ----------------------------------------------------------------------------

# p change(12) # [9, 3]
# p change(20) # [9, 6, 5] => this takes a long time

p change_tabu(9)  # [9]
p change_tabu(12) # [9, 3]
p change_tabu(20) # [9, 6, 5] => instantaneous
