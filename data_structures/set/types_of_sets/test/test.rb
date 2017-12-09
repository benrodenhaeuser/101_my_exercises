require 'simplecov'
SimpleCov.start

require 'minitest/autorun'

require_relative '../lib/numeric_map'
require_relative '../lib/set_like'
require_relative '../lib/multi_set'
require_relative '../lib/classical_set'
require_relative '../lib/fuzzy_set'

class NumericMapTest < Minitest::Test

end

class ClassicalSetTest < Minitest::Test
  def test_elements_are_not_counted
    # skip
    arr = [1, 2, 3, 4, 4]
    set = ClassicalSet.new(arr)
    actual_keys = set.keys
    expected_keys = arr.uniq
    assert_equal(expected_keys, actual_keys)
    actual_values = set.values.uniq
    expected_values = [1]
    assert_equal(expected_values, actual_values)
  end

  def test_adding_element_already_present_does_not_affect_size
    # skip
    set = ClassicalSet.new([0, 1, 2])
    set.add(1)
    actual = set.size
    expected = 3
    assert_equal(expected, actual)
  end

  def test_equality_is_order_independent
    # skip
    set1 = ClassicalSet.new([0, 1, 2])
    set2 = ClassicalSet.new([1, 2, 0])
    assert(set1.equivalent?(set2))
  end

  def test_equality_with_nested_sets
    # skip
    set1 = ClassicalSet.new([0, 1, 2])
    set2 = ClassicalSet.new([1, 2, 0])
    set3 = ClassicalSet.new([set1, 1, 2])
    set4 = ClassicalSet.new([1, set2, 2])
    assert(set1.equivalent?(set2))
    assert(set3.equivalent?(set4))
  end

  def test_equality_despite_repetitions
    # skip
    set1 = ClassicalSet.new([0, 1, 2, 2])
    set2 = ClassicalSet.new([0, 1, 2])
    assert(set1.equivalent?(set2))

    set3 = ClassicalSet.new([set1])
    set4 = ClassicalSet.new([set2])
    assert(set3.equivalent?(set4))
  end

  def test_equality_with_double_nesting_for_ordinary_sets
    # skip
    set1 = ClassicalSet.new([0, 1, 2])
    set2 = ClassicalSet.new([1, 2, 0])
    set3 = ClassicalSet.new([set1, 1, 2])
    set4 = ClassicalSet.new([set2, 1, 2])
    set5 = ClassicalSet.new([set3])
    set6 = ClassicalSet.new([set4])
    assert(set5.equivalent?(set6))
  end

  def test_proper_super_is_not_equal
    # skip
    set1 = ClassicalSet.new([0, 1, 2])
    set2 = ClassicalSet.new([0, 1, 2, 3])
    refute(set1.equivalent?(set2))
  end

  def test_add_an_element
    # skip
    set1 = ClassicalSet.new([0, 1, 2])
    set1.add(3)
    expected = ClassicalSet.new([0, 1, 3, 2])
    assert_equal(expected, set1)
  end

  def test_delete_an_element
    # skip
    set1 = ClassicalSet.new([0, 1, 2])
    set1.delete(2)
    assert_equal(ClassicalSet.new([0, 1]), set1)
  end

  def test_delete_is_like_remove_for_classical_sets
    # skip
    set1 = ClassicalSet.new([0, 1, 2, 2])
    set1.remove(2)
    actual = set1
    expected = ClassicalSet.new([0, 1])
    assert_equal(expected, actual)
  end

  def test_intersection
    # skip
    set1 = ClassicalSet.new([1, 2, 3, 4, 5])
    set2 = ClassicalSet.new([3, 4, 5, 6, 7])
    actual = set1.intersection(set2)
    expected = ClassicalSet.new([3, 4, 5])
    assert_equal(expected, actual)
  end

  def test_intersection!
    # skip
    set1 = ClassicalSet.new([1, 2, 3])
    set2 = ClassicalSet.new([1, 2, 3, 4, 5, 6])
    set1.intersection!(set2)
    actual = set1
    expected = ClassicalSet.new([1, 2, 3])
    assert_equal(expected, actual)
  end

  def test_difference
    # skip
    set1 = ClassicalSet.new([1, 2, 3])
    set2 = ClassicalSet.new([2, 3])
    expected = ClassicalSet.new([1])
    actual = set1.difference(set2)
    assert_equal(expected, actual)
  end

  def test_difference2
    # skip
    set1 = ClassicalSet.new([1, 2, 3])
    set2 = ClassicalSet.new([1, 4])
    expected = ClassicalSet.new([2, 3])
    assert_equal(expected, set1.difference(set2))
  end

  def test_union
    # skip
    set1 = ClassicalSet.new([1, 2, 3])
    set2 = ClassicalSet.new([4, 5, 6])
    expected = ClassicalSet.new([1, 2, 3, 4, 5, 6])
    assert_equal(expected, set1.union(set2))
  end

  def test_each_elem
    # skip
    set = ClassicalSet.new([0, 1, 2, 3])
    elems = []
    set.each_elem { |elem| elems << elem }
    expected = [0, 1, 2, 3]
    assert_equal(expected, elems)
  end

  def test_flatten_with_complicated_classical_set
    # skip
    set1 = ClassicalSet.new([1, 2, 3])
    set2 = ClassicalSet.new([set1, 4, 5])
    set3 = ClassicalSet.new([set2, 6, 7])
    set4 = ClassicalSet.new([set3, 1])
    set5 = ClassicalSet.new([set4, 4, set1])
    actual = set5.flatten
    expected = ClassicalSet.new([1, 2, 3, 4, 5, 6, 7])
    assert_equal(expected, actual)
  end

  def test_to_s_for_classical_set
    # skip
    set1 = ClassicalSet.new([1, 2, 3])
    set2 = ClassicalSet.new([set1, 4, 5])
    set3 = ClassicalSet.new([set2, 6, 7])
    set4 = ClassicalSet.new([set3, 1])
    set5 = ClassicalSet.new([set4, 4, set1])
    expected = '{{{{{1, 2, 3}, 4, 5}, 6, 7}, 1}, 4, {1, 2, 3}}'
    assert_equal(expected, set5.to_s)
  end
end

class MultiSetTest < Minitest::Test
  def test_initializing_with_invalid_hash_raises_exception
    # skip
    assert_raises ArgumentError do
      set = MultiSet.new(1 => -5)
    end
  end

  def test_each_elem
    # skip
    set = MultiSet.new(1 => 1, 2 => 1, 3 => 2)
    actual = set.each_elem.to_a
    expected = [1, 2, 3, 3]
    assert_equal(expected, actual)
  end

  def test_size
    # skip
    multi_set = MultiSet.new(1 => 1, 2 => 1, 3 => 2)
    actual = multi_set.size
    expected = 4
    assert_equal(expected, actual)
  end

  def test_include
    # skip
    multi_set = MultiSet.new(1 => 1, 2 => 1, 3 => 2)
    assert_includes(multi_set, 2)
  end

  def test_remove_key
    # skip
    multi_set = MultiSet.new(1 => 1, 2 => 1, 3 => 2)
    multi_set.remove(3)
    actual = multi_set
    expected = MultiSet.new(1 => 1, 2 => 1)
    assert_equal(expected, actual)
  end

  def test_delete
    # skip
    multi_set = MultiSet.new(1 => 1, 2 => 1, 3 => 2)
    multi_set.delete(3)
    actual = multi_set
    expected = MultiSet.new(1 => 1, 2 => 1, 3 => 1)
    assert_equal(expected, actual)
  end

  def test_sum!
    # skip
    multi_set1 = MultiSet.new(1 => 1, 2 => 1, 3 => 2)
    multi_set2 = MultiSet.new(2 => 1, 4 => 1)
    multi_set1.sum!(multi_set2)
    actual = multi_set1
    expected = MultiSet.new(1 => 1, 2 => 2, 3 => 2, 4 => 1)
    assert_equal(expected, actual)
  end

  def test_union!
    # skip
    multi_set1 = MultiSet.new(1 => 1, 2 => 1, 3 => 2)
    multi_set2 = MultiSet.new(2 => 1, 4 => 1)
    multi_set1.union!(multi_set2)
    actual = multi_set1
    expected = MultiSet.new(1 => 1, 2 => 1, 3 => 2, 4 => 1)
    assert_equal(expected, actual)
  end

  def test_difference!
    # skip
    multi_set1 = MultiSet.new(1 => 1, 2 => 1, 3 => 2)
    multi_set2 = MultiSet.new(3 => 3)
    actual = multi_set1.difference(multi_set2)
    expected = MultiSet.new(1 => 1, 2 => 1)
    assert_equal(expected, actual)
  end

  def test_sum
    # skip
    multi_set1 = MultiSet.new(1 => 1, 2 => 1, 3 => 2)
    multi_set2 = MultiSet.new(2 => 1, 4 => 1)
    actual = multi_set1.sum(multi_set2)
    expected = MultiSet.new(1 => 1, 2 => 2, 3 => 2, 4 => 1)
    assert_equal(expected, actual)
  end

  def test_sum_is_non_destructive # todo: fails
    # skip
    multi_set1 = MultiSet.new(1 => 1, 2 => 1, 3 => 2)
    multi_set2 = MultiSet.new(2 => 1, 4 => 1)
    multi_set1.sum(multi_set2)
    actual = multi_set1
    expected = MultiSet.new(1 => 1, 2 => 1, 3 => 2)
    assert_equal(expected, actual)
  end

  def test_union
    # skip
    multi_set1 = MultiSet.new(1 => 1, 2 => 1, 3 => 2)
    multi_set2 = MultiSet.new(2 => 1, 4 => 1)
    actual = multi_set1.union(multi_set2)
    expected = MultiSet.new(1 => 1, 2 => 1, 3 => 2, 4 => 1)
    assert_equal(expected, actual)
  end

  def test_union_is_non_destructive # todo: fails
    # skip
    multi_set1 = MultiSet.new(1 => 1, 2 => 1, 3 => 2)
    multi_set2 = MultiSet.new(2 => 1, 4 => 1)
    multi_set1.union(multi_set2)
    actual = multi_set1
    expected = MultiSet.new(1 => 1, 2 => 1, 3 => 2)
    assert_equal(expected, actual)
  end

  def test_intersection
    # skip
    multi_set1 = MultiSet.new(1 => 1, 2 => 1, 3 => 2)
    multi_set2 = MultiSet.new(3 => 3)
    actual = multi_set1.intersection(multi_set2)
    expected = MultiSet.new(3 => 2)
    assert_equal(expected, actual)
  end

  def test_difference
    # skip
    multi_set1 = MultiSet.new(1 => 1, 2 => 1, 3 => 2)
    multi_set2 = MultiSet.new(3 => 3)
    actual = multi_set1.difference(multi_set2)
    expected = MultiSet.new(1 => 1, 2 => 1)
    assert_equal(expected, actual)
  end

  def test_difference_is_non_destructive
    # skip
    multi_set1 = MultiSet.new(1 => 1, 2 => 1, 3 => 2)
    multi_set2 = MultiSet.new(3 => 3)
    multi_set1.difference(multi_set2)
    actual = multi_set1
    expected = MultiSet.new(1 => 1, 2 => 1, 3 => 2)
    assert_equal(expected, actual)
  end

  def test_subset
    # skip
    multi_set1 = MultiSet.new(1 => 1, 2 => 1, 3 => 2)
    multi_set2 = MultiSet.new(1 => 1, 2 => 1, 3 => 2, 4 => 1, 5 => 1)
    multi_set3 = MultiSet.new(1 => 1, 2 => 1, 3 => 1)
    assert(multi_set1.subset?(multi_set2))
    refute(multi_set1.subset?(multi_set3))
  end

  def test_proper_sub
    # skip
    multi_set1 = MultiSet.new([1, 2, 3, 3])
    multi_set2 = MultiSet.new([1, 2, 3, 3, 4, 5])
    multi_set3 = MultiSet.new([1, 2, 3])
    assert(multi_set1.proper_subset?(multi_set2))
    refute(multi_set1.proper_subset?(multi_set3))
  end

  def test_super
    # skip
    multi_set1 = MultiSet.new([1, 2, 3, 3])
    multi_set2 = MultiSet.new([1, 2, 3, 3, 4, 5])
    multi_set3 = MultiSet.new([1, 2, 3])
    assert(multi_set2.superset?(multi_set1))
    refute(multi_set3.superset?(multi_set1))
  end

  def test_proper_super
    # skip
    multi_set1 = MultiSet.new([1, 2, 3, 3])
    multi_set2 = MultiSet.new([1, 2, 3, 3, 4, 5])
    multi_set3 = MultiSet.new([1, 2, 3])
    assert(multi_set2.proper_superset?(multi_set1))
    refute(multi_set3.proper_superset?(multi_set3))
  end

  def test_equivalence
    # skip
    multi_set1 = MultiSet.new([1, 2, 3, 3])
    multi_set2 = MultiSet.new([1, 2, 3, 3])
    multi_set3 = MultiSet.new([1, 2, 3])
    assert(multi_set1.equivalent?(multi_set2))
    refute(multi_set1.equivalent?(multi_set3))
  end

  def test_equality_with_nested_sets_for_MultiSets
    # skip
    set1 = MultiSet.new([0, 1, 2])
    set2 = MultiSet.new([1, 2, 0])
    set3 = MultiSet.new([set1, 1, 2])
    set4 = MultiSet.new([set2, 1, 2])
    assert(set1.equivalent?(set2))
    assert(set3.equivalent?(set4))
  end

  def test_equality_with_double_nesting
    # skip
    set1 = MultiSet.new([0, 1, 2])
    set2 = MultiSet.new([1, 2, 0])
    set3 = MultiSet.new([set1, 1, 2])
    set4 = MultiSet.new([set2, 1, 2])
    set5 = MultiSet.new([set3])
    set6 = MultiSet.new([set4])
    assert(set5.equivalent?(set6))
  end

  def test_each_elem_with_a_block
    # skip
    multi_set = MultiSet.new([1, 2, 3, 3])
    array = []
    multi_set.each_elem { |elem| array << elem }
    assert_equal(array, [1, 2, 3, 3])
  end

  def test_each_without_block
    # skip
    MultiSet.new.each.instance_of?(Enumerator)
  end

  def test_remove_decrements_elem_count
    # skip
    set = MultiSet.new([1, 2, 3, 3])
    set.delete(3)
    assert_equal(set.retrieve(3), 1)
  end

  def test_negative_elem_counts_do_not_occur
    # skip
    set = MultiSet.new([1, 2, 3])
    set.delete(1)
    set.delete(1)
    expected = 0
    assert_equal(0, set.retrieve(1))
  end

  def test_destructive_intersection
    # skip
    multi_set1 = MultiSet.new([1, 2, 3])
    multi_set2 = MultiSet.new([2, 3, 4])
    multi_set1.intersection!(multi_set2)
    expected = MultiSet.new([2, 3])
    assert_equal(expected, multi_set1)
  end

  def test_flatten
    # skip
    set1 = MultiSet.new([1, 2, 3])
    set2 = MultiSet.new([set1, 4, 5])
    set3 = MultiSet.new([set2, 6, 7])
    actual = set3.flatten
    expected = MultiSet.new([1, 2, 3, 4, 5, 6, 7])
    assert_equal(expected, actual)
  end

  def test_flatten_with_elements_appearing_multiple_times
    # skip
    set1 = MultiSet.new([1, 2, 3, 3])
    set2 = MultiSet.new([set1, 4, 5])
    set3 = MultiSet.new([set2, 6, 6, 7])
    actual = set3.flatten
    expected = MultiSet.new([1, 2, 3, 3, 4, 5, 6, 6, 7])
    assert_equal(expected, actual)
  end

  def test_flatten_with_complicated_set
    # skip
    set1 = MultiSet.new([1, 2, 3])
    set2 = MultiSet.new([set1, 4, 5])
    set3 = MultiSet.new([set2, 6, 7])
    set4 = MultiSet.new([set3, 1])
    set5 = MultiSet.new([set4, 4, set1])

    actual = set5.flatten
    expected = MultiSet.new([1, 2, 3, 4, 5, 6, 7, 1, 4, 1, 2, 3])
    assert_equal(expected, actual)
  end

  def test_to_s
    # skip
    set1 = MultiSet.new([1, 2, 3, 3])
    set2 = MultiSet.new([set1, 4, 5, 5])
    set3 = MultiSet.new([set2, 6, 6, 7])
    set4 = MultiSet.new([set3, 1])
    set5 = MultiSet.new([set4, 4, set1])
    actual = set5.to_s
    expected = '{({({({({(1: 1), (2: 1), (3: 2)}: 1), (4: 1), (5: 2)}: 1), (6: 2), (7: 1)}: 1), (1: 1)}: 1), (4: 1), ({(1: 1), (2: 1), (3: 2)}: 1)}'
    assert_equal(expected, set5.to_s)
  end
end

class FuzzySetTest < Minitest::Test
  def test_initializing_with_invalid_hash_raises_exception
    # skip
    assert_raises ArgumentError do
      set = FuzzySet.new(1 => 10)
    end
  end
end
