require 'minitest/autorun'
require_relative 'tail_recursion'

class TailRecursionTest < Minitest::Test
  def test_sum
    expected = 1 + 2 + 3 + 4 + 5 + 6
    assert_equal(expected, TailRecursion.sum(6))
  end

  def test_factorial
    expected = 1 * 2 * 3 * 4 * 5 * 6
    assert_equal(expected, TailRecursion.factorial(6))
  end

  def test_fibonacci_head
    expected = 8
    assert_equal(expected, TailRecursion.fibonacci_head(6))
  end

  def test_fibonacci_tail_for_0
    expected = 0
    assert_equal(expected, TailRecursion.fibonacci(0))
  end

  def test_fibonacci_tail_for_1
    expected = 1
    assert_equal(expected, TailRecursion.fibonacci(1))
  end

  def test_fibonacci_tail_for_2
    expected = 1
    assert_equal(expected, TailRecursion.fibonacci(2))
  end

  def test_fibonacci_tail_for_10
    expected = TailRecursion.fibonacci_head(10)
    assert_equal(expected, TailRecursion.fibonacci(10))
  end
end
