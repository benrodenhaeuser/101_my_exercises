class Array
  def my_each
    for elem in self
      yield(elem)
    end
    self
  end
end

[0, 1, 2].my_each do |elem|
  puts elem
end

# =>
# 0
# 1
# 2
