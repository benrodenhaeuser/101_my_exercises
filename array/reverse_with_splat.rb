# use splat operator to reverse array

def reverse(array)
  new_array = []
  array.size.times do
    *initial, last = array
    new_array << last
    array = initial
  end
  new_array
end

array = [0, 1, 2, 3, 4]
p reverse(array) == [4, 3, 2, 1, 0] # => true
p array == [0, 1, 2, 3, 4] # => true

array = []
p reverse(array) == [] # => true

p reverse([1,2,3,4]) == [4,3,2,1]          # => true
p reverse(%w(a b c d e)) == %w(e d c b a)  # => true
p reverse(['abc']) == ['abc']              # => true
p reverse([]) == []                        # => true

list = [1, 2, 3]                      # => [1, 2, 3]
new_list = reverse(list)              # => [3, 2, 1]
p list.object_id != new_list.object_id  # => true
p list == [1, 2, 3]                     # => true
p new_list == [3, 2, 1]                 # => true
