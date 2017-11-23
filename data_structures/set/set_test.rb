require 'minitest/autorun'
require_relative 'my_set'
require_relative 'multi_set_2'

class MySetTest < Minitest::Test
  def test_equality_is_order_independent
    set1 = MySet.new([0, 1, 2])
    set2 = MySet.new([1, 2, 0])
    assert(set1 == set2)
  end

  def test_adding_elements_present_is_redundant
    set = MySet.new([0, 1, 2])
    set << 1
    expected = 3
    assert_equal(expected, set.size)
  end

  def test_equality_with_nested_sets
    set1 = MySet.new([0, 1, 2])
    set2 = MySet.new([1, 2, 0])
    set3 = MySet.new([set1, 1, 2])
    set4 = MySet.new([1, set2, 2])
    assert(set3 == set4)
  end

  def test_to_s
    set1 = MySet[1, 2, 3]
    set2 = MySet[set1, 4, 5]
    set3 = MySet[set2, 6, 7]
    set4 = MySet[set3, 1]
    set5 = MySet[set4, 4, set1]
    expected = '{{{{{1, 2, 3}, 4, 5}, 6, 7}, 1}, 4, {1, 2, 3}}'
    assert_equal(expected, set5.to_s)
  end

  def test_proper_superset_is_not_equal
    set1 = MySet.new([0, 1, 2])
    set2 = MySet.new([0, 1, 2, 3])
    refute(set1 == set2)
  end

  def test_add_an_element
    set1 = MySet.new([0, 1, 2])
    set1 << 3
    expected = MySet.new([0, 1, 3, 2])
    assert_equal(expected, set1)
  end

  def test_delete_an_element
    set1 = MySet.new([0, 1, 2])
    expected = MySet.new([0, 1])
    assert_equal(expected, set1.delete(2))
  end

  def test_intersect
    set1 = MySet.new([1, 2, 3, 4, 5])
    set2 = MySet.new([3, 4, 5, 6, 7])
    expected = MySet.new([3, 4, 5])
    assert_equal(expected, set1 & set2)
  end

  def test_subtract
    set1 = MySet.new([1, 2, 3])
    set2 = MySet.new([2, 3])
    expected = [1]
    set1.subtract(set2)
    assert_equal(expected, set1.to_a)
  end

  def test_merge
    set1 = MySet.new([1, 2, 3])
    set2 = MySet.new([4, 5, 6])
    set1.merge(set2)
    expected = [1, 2, 3, 4, 5, 6]
    assert_equal(expected, set1.to_a)
  end

  def test_cannot_intersect_set_with_non_enum
    set = MySet.new
    assert_raises(ArgumentError) do
      set & 1
    end
  end

  def test_union
    set1 = MySet.new([1, 2, 3])
    set2 = MySet.new([4, 5, 6])
    expected = MySet.new([1, 2, 3, 4, 5, 6])
    assert_equal(expected, set1 + set2)
  end

  def test_difference
    set1 = MySet.new([1, 2, 3])
    array = [1, 4]
    expected = MySet.new([2, 3])
    assert_equal(expected, set1 - array)
  end

  def test_each
    set = MySet.new([0, 1, 2, 3])
    elems = []
    set.each { |elem| elems << elem }
    expected = [0, 1, 2, 3]
    assert_equal(expected, elems)
  end

  def test_select
    set1 = MySet.new([0, 1, 2, 3])
    set2 = set1.select { |elem| elem.odd? }
    expected = MySet.new([1, 3])
    assert_equal(expected, set2)
  end

  def test_map
    set1 = MySet.new(['a', 'b', 'c', 'd'])
    set2 = set1.map { |elem| elem * 2 }
    expected = MySet.new(['aa', 'bb', 'cc', 'dd'])
    assert_equal(expected, set2)
  end

  def test_flatten
    set1 = MySet[1, 2, 3]
    set2 = MySet[set1, 4, 5]
    set3 = MySet[set2, 6, 7]
    expected = [1, 2, 3, 4, 5, 6, 7]
    assert_equal(expected, set3.flatten.to_a)
  end

  def test_flatten_with_duplicates_in_nested_sets
    set1 = MySet[1, 2, 3]
    set2 = MySet[set1, 4, 5]
    set3 = MySet[set2, 6, 7]
    set4 = MySet[set3, 1]
    set5 = MySet[set4, 4, set1]
    expected = MySet[1, 2, 3, 4, 5, 6, 7]
    assert_equal(expected, set5.flatten)
  end
end

class MultiSetTest < Minitest::Test
  def test_initialize_and_to_a
    multi_set = MultiSet[1, 2, 3, 3]
    expected = [1, 2, 3, 3]
    assert_equal(expected, multi_set.to_a)
  end

  def test_size
    multi_set = MultiSet[1, 2, 3, 3]
    expected = 4
    assert_equal(expected, multi_set.size)
  end

  def test_elem_count_getter
    multi_set = MultiSet[1, 2, 3, 3]
    expected = 2
    assert_equal(expected, multi_set[3])
  end

  def test_elem_count_getter_alias
    multi_set = MultiSet[1, 2, 3, 3]
    expected = 2
    assert_equal(expected, multi_set[3])
  end

  def test_elem_count_setter
    multi_set = MultiSet[1, 2, 3, 3]
    multi_set[2] = 2
    expected = [1, 2, 2, 3, 3]
    assert_equal(expected, multi_set.to_a)
  end

  def test_add_element
    multi_set = MultiSet[1, 2, 3, 3]
    multi_set.add(5)
    expected = [1, 2, 3, 3, 5]
    assert_equal(expected, multi_set.to_a)
  end

  def test_sum!
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[2, 4]
    multi_set1.sum!(multi_set2)
    expected = 2
    assert_equal(expected, multi_set1[2])
  end

  def test_union!
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[2, 4]
    multi_set1.merge(multi_set2)
    expected = [1, 2, 3, 3, 4]
    assert_equal(expected, multi_set1.to_a)
  end

  def test_intersection!

  end

  def test_difference!

  end

  def test_sum

  end

  def test_union

  end

  def test_intersection

  end

  def test_difference

  end

  def test_each_with_block
    multi_set = MultiSet[1, 2, 3, 3]
    array = []
    multi_set.each { |elem| array << elem }
    assert_equal(array, [1, 2, 3, 3])
  end

  def test_each_without_block
    MultiSet.new.each.instance_of?(Enumerator)
  end
end

class SetTest < Minitest::Test
  def test_sum_undefined
    set1 = Set[1, 2, 3]
    set2 = set1
    assert_raises NoMethodError do
      set1.sum!(set2)
    end
    assert_raises NoMethodError do
      set1.sum(set2)
    end
  end

  def test_that_not_counting_elements_works
    set = Set[1, 2, 3, 4, 4]
    expected = [1, 2, 3, 4]
    assert_equal(expected, set.to_a)
  end
end
