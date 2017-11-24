# something
class MyClass
  include MyModule

  def initialize
    my_method
  end
end

# some other thing
module MyModule
  def my_method
    puts "I will return your call"
  end
end

MyClass.new
