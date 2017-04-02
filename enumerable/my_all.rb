class Array
  def my_all?
    result = true
    for elem in self
      result = false unless yield(elem)
    end
    result
  end
end

result = [0, 1, 2].my_all? do |elem|
  elem.even?
end

p result # => false, because 1 is odd, i.e., not all are even

result = [0, 2, 4].my_all? do |elem|
  elem.even?
end

p result # => true, because they are all even

result = [].my_all? do |elem|
  elem.even?
end

p result # => vacuously true
