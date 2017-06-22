# given a set and an integer k, produce the k-combinations of the set.

require 'set'

# ---------------------------------------------------------------------------
# k-combinations of a set
# ---------------------------------------------------------------------------

def combine_set(set, k)
  if k == 0
    [[].to_set].to_set
  elsif k == 1
    set.map { |elem| [elem].to_set }.to_set
  elsif set.size >= k
    elem = set.to_a.first
    combine_set(set.select { |other| elem != other }, k - 1).map { |combo| [elem].to_set + combo }.to_set +
    combine_set(set.select { |other| elem != other }, k)
  else
    [].to_set
  end
end

# ---------------------------------------------------------------------------
# k-combinations of an array
# ---------------------------------------------------------------------------

def combine_array(array, k)
  if k == 0
    [[]]
  elsif k == 1
    array.map { |elem| [elem] }
  elsif array.size >= k
    combine_array(array[1..-1], k - 1).map { |combo| [array[0]] + combo } +
    combine_array(array[1..-1], k)
  else
    []
  end
end

# ---------------------------------------------------------------------------
# tests
# ---------------------------------------------------------------------------

# k-combinations of array

p combine_array([1, 2], 3)
# => []

p combine_array([], 1)
# => []

p combine_array([1, 2], 0)
# => [[]]

p combine_array([1, 2, 3, 4], 2)
# => [[1, 2], [1, 3], [1, 4], [2, 3], [2, 4], [3, 4]]

p combine_array([1, 2, 3, 4], 3)
# => [[1, 2, 3], [1, 2, 4], [1, 3, 4], [2, 3, 4]]

p combine_array([1, 2, 3, 4, 5], 5)
# => [[1, 2, 3, 4, 5]]

# -----

# k-combinations of set

p combine_set([1, 2].to_set, 3)
# => empty set

p combine_set([].to_set, 1)
# => empty set

p combine_set([1, 2].to_set, 0)
# => singleton containing empty set

p combine_set([1, 2, 3, 4].to_set, 2)
# => #<Set: {#<Set: {1, 2}>, #<Set: {1, 3}>, #<Set: {1, 4}>, #<Set: {2, 3}>, #<Set: {2, 4}>, #<Set: {3, 4}>}>

p combine_set([1, 2, 3, 4].to_set, 3)
# => #<Set: {#<Set: {1, 2, 3}>, #<Set: {1, 2, 4}>, #<Set: {1, 3, 4}>, #<Set: {2, 3, 4}>}>

p combine_set([1, 2, 3, 4, 5].to_set, 5)
# => #<Set: {#<Set: {1, 2, 3, 4, 5}>}>
