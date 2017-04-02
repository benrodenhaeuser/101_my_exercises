class Array
  def my_map
    new_ary = []
    for elem in self
      return_value = yield(elem)
      new_ary << return_value
    end
    new_ary
  end
end

new_ary = [0, 1, 2].my_map do |elem|
  elem * 2
end

p new_ary
# =>
# 0
# 2
# 4
