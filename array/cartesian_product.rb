# write a method that returns the cartesian product of two given lists.


# solution with each and map

def cartesian_product(array1, array2)
  result = []
  array1.each do |elem|
    result +=
      array2.map do |other_elem|
        [elem, other_elem]
      end
  end
  result
end

p cartesian_product([1, 2, 3], ['a', 'b', 'c'])
#=> [[1, "a"], [1, "b"], [1, "c"], [2, "a"], [2, "b"], [2, "c"], [3, "a"], [3, "b"], [3, "c"]]
