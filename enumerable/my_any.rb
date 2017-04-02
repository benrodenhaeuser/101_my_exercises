class Array
  def my_any
    for elem in self
      return true if yield(elem)
    end
    false
  end
end

result = [0, 1, 2].my_any do |elem|
  elem.even?
end

p result # => true, because 0 and 2 are even

result = [0, 2, 4].my_any do |elem|
  elem.even?
end

p result # => true, because they are all even

result = [].my_any do |elem|
  elem.even?
end

p result # => false, because there was no elem for which a truthy value was returned
