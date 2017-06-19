# given a set, produce the powerset.

require 'set'

# ---------------------------------------------------------------------------
# k-combinations of an array
# ---------------------------------------------------------------------------

# assume that k > 0

def combine_array(array, k)
  return [[]] if k == 0

  if k == 1
    array.map { |elem| [elem] }
  elsif array.size >= k
    combine_array(array[1..-1], k - 1).map { |combo| [array[0]] + combo } +
    combine_array(array[1..-1], k)
  else
    []
  end
end

# this produces the k-combinations in lexicographic order.

# ---------------------------------------------------------------------------
# k-combinations of a set
# ---------------------------------------------------------------------------

# since combinations are distinguished by the fact that order does not matter, sets seem an appropriate choice of data structure.

def combine_set(set, k)
  return [[].to_set].to_set if k == 0

  if k == 1
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
# generate all subarrays of array
# ---------------------------------------------------------------------------

# Observation: Since we now have a procedure that computes all k-combinations of a given array (or set), we can also compute *all* subarrays of a given array (or the powerset of a given set).

def subarrays(array)
  subarrays = []
  (0..array.size).each { |k| subarrays += combine_array(array, k) }
  subarrays
end

# ---------------------------------------------------------------------------
# generate the powerset
# ---------------------------------------------------------------------------

def powerset(set)
  powerset = [].to_set
  (0..set.size).each { |k| powerset += combine_set(set, k) }
  powerset
end

# this will produce the powerset in its "natural" ordering (i.e., go from small to big and order subsets of the same size lexicographically).

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

# -----

# all subarrays

p subarrays([1, 2, 3])
# => [[], [1], [2], [3], [1, 2], [1, 3], [2, 3], [1, 2, 3]]


# powerset

set = [1, 2, 3].to_set
p powerset(set)
# => #<Set: {#<Set: {}>, #<Set: {1}>, #<Set: {2}>, #<Set: {3}>, #<Set: {1, 2}>, #<Set: {1, 3}>, #<Set: {2, 3}>, #<Set: {1, 2, 3}>}>
