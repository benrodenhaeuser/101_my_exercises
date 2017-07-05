=begin

Suppose we could access yesterday's stock prices as a list, where:

The values are the price in dollars of Apple stock.
A higher index indicates a later time.
So if the stock cost $500 at 10:30am and $550 at 11:00am, then:

stock_prices_yesterday[60] = 500

Write an efficient function that takes stock_prices_yesterday and returns the best profit I could have made from 1 purchase and 1 sale of 1 Apple stock yesterday.

Understanding/Requirements:

- given array of positive integers.
- find indices a and b from the given array such that a < b and array[b] - array[a] is *maximal*, i.e., there is no pair of indices c, d such that c < d and array[d] - array[c] is larger than array[b] - array[a].
- return array[b] - array[a]

Edge cases:
- what to do if prices drop throughout a given day? Suggestion: return a negative profit in this case.
- what if array has less than 2 elements? Suggestion: assume that there are at least two elements.

Examples:

[10, 7, 5, 8, 11, 9]
=> buy for 5, sell for 11 => return 6

[10, 9, 8]
=> buy for 9, sell for 8 => at a loss of 1, i.e., return -1

Algorithm:
1) Initialize integer `profit` to array[1] - array[0].
2) (High-level recipe) For each indices i and j such that i < j: check if array[j] - array[i] > profit. If so, re-assign profit to array[j] - array[i].
3) Return profit after having considered all appropriate pairs of indices.

Breaking down step (2):

for each element of the array with index i:
  for each element of the array obtained by dropping i + 1 elements from array:
    profit = array[j] - array[i] if array[j] - array[i] > profit

=end

def get_max_profit(array)
  profit = array[1] - array[0]
  array.each_with_index do |elem1, index|
    array.drop(index + 1).each do |elem2|
      profit = elem2 - elem1 if elem2 - elem1 > profit
    end
  end
  profit
end

stock_prices_yesterday = [10, 7, 5, 8, 11, 9]
p get_max_profit(stock_prices_yesterday) == 6
# (buy for $5, selling for $11)

stock_prices_yesterday = [10, 9, 8, 7, 6, 5]
p get_max_profit(stock_prices_yesterday) == -1
# buy for 6, sell for 5 (minimize damages)


# Instructor hint: "You can do this in O(n) time and O(1) space!"
