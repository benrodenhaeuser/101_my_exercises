# generate all partitions of a set { 0, ..., n - 1 }.

require 'set'

=begin

**idea**

the set of partitions of a set S allows for a recursive definition:

{ {S'} \cup P' | S' \subseteq S, P' is a partition of S \ S' }

the base cases for a singleton and an empty set are the obvious ones.

this could be the basis for a recursive algorithm.

**pseudocode**

generate_partitions of S:
  if the size of S is 0:
    return { { } }, i.e., the set containing only the empty set
  if the size of S is 1:
    return { { S } }, i.e., the set containing the set containing only S
  else:
    partitions = {} (i.e., the empty set)
    non_empty_proper_subsets(S' of S ).each:
      partitions(P' of S \minus S').each:
        partitions << { S' } \cup P'
    return partitions << S (S itself is also a partition!)

=end

# ---------------------------------------------------------------------------
# solution 1: based on powerset
# ---------------------------------------------------------------------------

# we make use of an auxiliary method non_empty_proper_subsets, which gives the powerset minus the top and bottom elements. this auxiliary method is defined in terms of another auxiliary method which gives the k-combinations of a set, i.e., the subsets of cardinality k.

def partitions(set)
  if set.size == 0
    [set].to_set # { {} }
  elsif set.size == 1
    [[set].to_set].to_set # { { set } }
  else
    partitions = [].to_set
    non_empty_proper_subsets(set).each do |subset|
      partitions(set - subset).each do |partition|
        partitions << ([subset].to_set + partition)
      end
    end
    partitions << [set].to_set
  end
end

def non_empty_proper_subsets(set)
  powerset = [].to_set
  (1...set.size).each { |k| powerset += combinations(set, k) }
  powerset
end

def combinations(set, k)
  if k == 0
    [[].to_set].to_set
  elsif k == 1
    set.map { |elem| [elem].to_set }.to_set
  elsif set.size >= k
    elem = set.to_a.first
    combinations(set.select { |other| elem != other }, k - 1).map { |combo| [elem].to_set + combo }.to_set +
    combinations(set.select { |other| elem != other }, k)
  else
    [].to_set
  end
end

# this solution computes many partitions several times.
# consider partitions of the set {1, 2, 3}.
# if we have computed a partial partition { {1}, {2} }, then we can expand it
# with { 3 } to { {1}, {2}, {3} }.
# but at the same time, we will also compute a partial partition { {1}, {3} }
# and expand it with { 2 }, also to { {1}, {2}, {3} }.
# So that is just one example of wasted resources.

# what could be done about this?

# maybe the refinement order on the partitions is interesting here. the above solution generates partial partitions (partitions of smaller sets), which are expanded to total partitions (partitions of the initial set). a solution that uses the refinement order would generate an initial total partition, and succesively change it to other total partitions (by making refinement steps). if we memoize results so far, this should make it a lot easier to avoid computing many duplicates.

# ---------------------------------------------------------------------------
# TODO solution 2: based on refinement
# ---------------------------------------------------------------------------

# pseudocode (not yet working)

# given set S
#
# partitions = []
# partition = finest_partition(S)
# while partition != S
#   take "next" pair of elements from partition
#   partition = union of pair plus rest of partition
#   partitions << partition
#
# ???


# ---------------------------------------------------------------------------
# tests
# ---------------------------------------------------------------------------


set = [].to_set
p partitions(set)
#<Set: {#<Set: {}>}>

set = [1].to_set
p partitions(set)
#<Set: {#<Set: {#<Set: {1}>}>}>

set = [1, 2].to_set
p partitions(set)
#<Set: {#<Set: {#<Set: {1}>, #<Set: {2}>}>, #<Set: {#<Set: {1, 2}>}>}>

set = [1, 2, 3].to_set
p partitions(set)
#<Set: {#<Set: {#<Set: {1}>, #<Set: {2}>, #<Set: {3}>}>, #<Set: {#<Set: {1}>, #<Set: {2, 3}>}>, #<Set: {#<Set: {2}>, #<Set: {1, 3}>}>,
#<Set: {#<Set: {3}>, #<Set: {1, 2}>}>, #<Set: {#<Set: {1, 2, 3}>}>}>

# set = (0..5).to_a.to_set
# p partitions(set)
