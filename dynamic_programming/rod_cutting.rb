# Rod Cutting

# (CLRS, p. 360)

# Given a rod of length n and a table of prices for rod pieces from 1 to n, determine the maximum revenue obtainable by cutting up the rod (0 or more times) and selling the pieces.

# ----------------------------------------------------------------------------
# problem instance
# ----------------------------------------------------------------------------

# let's first solve a specific problem instance:
# - we are given a price list for rod pieces of length 1 to 4.
# - we wish to determine the maximum revenue we can obtain for a
#   rod of length 4.
# - we can make arbitrary integer cuts.

# the given price list:
price_list = { 1 => 1, 2 => 5, 3 => 8, 4 => 9 }

# a rod of length 0 yields maxium revenue 0:
max_revenue = [0]

# iteratively determine maximum revenues for rods of length 1 up to 4:
1.upto(4) do |rod_length|
  candidates = []
  1.upto(rod_length) do |cut_off|
    candidates << price_list[cut_off] + max_revenue[rod_length - cut_off]
  end

  max_revenue[rod_length] = candidates.max
end

# print the maximum revenue for a rod of length 4:
# p max_rev[4] # 10

# ----------------------------------------------------------------------------
# solution
# ----------------------------------------------------------------------------

def max_revenue(price_list, my_rod_length)
  max_revenue = [0]

  1.upto(my_rod_length) do |rod_length|
    candidates = []
    1.upto(rod_length) do |cut_off|
      candidates << price_list[cut_off] + max_revenue[rod_length - cut_off]
    end

    max_revenue[rod_length] = candidates.max
  end

  max_revenue[my_rod_length]
end

# ----------------------------------------------------------------------------
# tests
# ----------------------------------------------------------------------------

price_list = {
  1 => 1, 2 => 5, 3 => 8, 4 => 9, 5 => 10,
  6 => 17, 7 => 17, 8 => 20, 9 => 24, 10 => 30
}

p max_revenue(price_list, 4) # 10
p max_revenue(price_list, 6) # 17
p max_revenue(price_list, 10) # 30
