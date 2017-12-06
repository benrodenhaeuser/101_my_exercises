module InTest
  def test_meth
    puts "hello!"
  end
end

module Test
  include InTest
end

class TestClass
  include Test

  def call_module_method
    test_meth
  end

end

TestClass.new.call_module_method
