require 'simplecov'
SimpleCov.start

require 'minitest/autorun'

require_relative '../lib/my_ruby_file'

class TestMyClass < Minitest::Test
  def test_my_test_method
    actual = TestClass.new.my_test_method
    expected = 10
    assert_equal(expected, actual)
  end
end
