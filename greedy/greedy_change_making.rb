# given the denominations quarter (25 cents), dime (10 cents), nickel (5 cents)
# and penny (1 cent), give change for amounts up to 99 cent.

DENOMS = [25, 10, 5, 1]

def change(amount)
  change = []
  while amount > 0
    best_choice = DENOMS.select { |denom| amount - denom >= 0 }.max
    change << best_choice
    amount -= best_choice
  end
  change
end

p change(48) # => [25, 10, 10, 1, 1, 1]
