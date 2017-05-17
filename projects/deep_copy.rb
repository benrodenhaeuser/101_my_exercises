# deep_copy produces a deep copy of its input.
#
# Valid inputs to deep_copy are arbitrarily nested arrays and hashes
# built from strings, symbols, and numerics.

def immutable?(obj)
  obj.instance_of?(Symbol) || obj.is_a?(Numeric)
end

def string?(obj)
  obj.instance_of?(String)
end

def array?(obj)
  obj.instance_of?(Array)
end

def hash?(obj)
  obj.instance_of?(Hash)
end

def deep_copy(obj)
  if immutable?(obj)
    obj_copy = obj
  elsif string?(obj)
    obj_copy = obj.clone
  elsif array?(obj) # respond_to?(:each)
    obj_copy = Array.new
    obj.each { |value| obj_copy << deep_copy(value) }
  elsif hash?(obj)
    obj_copy = Hash.new
    obj.each { |key, value| obj_copy[deep_copy(key)] = deep_copy(value) }

  else
    puts "#{obj} cannot be copied!"
  end

  obj_copy
end

# alternative way, relying on duck typing

def deep_copy(obj)
  if immutable?(obj)
    obj_copy = obj
  elsif string?(obj)
    obj_copy = obj.clone
  elsif array?(obj)
    obj_copy = Array.new
    obj.each { |value| obj_copy << deep_copy(value) }
  elsif hash?(obj)
    obj_copy = Hash.new
    obj.each { |key, value| obj_copy[deep_copy(key)] = deep_copy(value) }

  else
    puts "#{obj} cannot be copied!"
  end

  obj_copy
end



# test

def different_ids?(obj, obj_copy)
  object_ids_differ = true
  unless immutable?(obj)
    object_ids_differ = obj.object_id != obj_copy.object_id
  end

  nested_object_ids_differ = true
  if array?(obj) || hash?(obj)
    obj = obj.to_a
    obj_copy = obj_copy.to_a

    nested_object_ids_differ = (0...obj.size).all? do |index|
      different_ids?(obj[index], obj_copy[index])
    end
  end

  object_ids_differ && nested_object_ids_differ
end

def same_values?(obj, obj_copy)
  obj == obj_copy
end

def test_deep_copy(obj)
  obj_copy = deep_copy(obj)
  puts "Original: #{obj}"
  puts "Copy:     #{obj_copy}"
  puts "Original and copy store the same values? #{same_values?(obj, obj_copy)}"
  puts "They have different object ids throughout? #{different_ids?(obj, obj_copy)}"
end

arr = ['a', ['b', 'c'], ['d', ['e', ['f', 'g']]]]
test_deep_copy(arr)

puts

arr2 = [1, { two: "val", three: "val" }, ["s1", ["s3"]], [1.3, 2.4, 3.2]]
test_deep_copy(arr2)

puts

hash = { ['s1', 's2'] => ['a', { b: 'c' }, ['d', ['e', ['f', 'g']]]] }
test_deep_copy(hash)

puts

hash2 = { ['a', ['b', 'c'], ['d', ['e', ['f', 'g']]]] => 'v' }
test_deep_copy(hash2)
