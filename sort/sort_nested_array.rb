# Come up with code to sort the outer array so that the inner arrays are ordered according to the numeric value of the strings they contain.

# solution 1: the crucial observation is that we need to do element-wise comparisons on the inner arrays. 

arr =
  [['1', '8', '11'], ['2', '6', '13'], ['2', '12', '15'], ['1', '8', '9']]

sorted = arr.sort do |elem1, elem2|
  result = 0
  elem1.each_index do |index|
    if elem1[index] != elem2[index]
      result = (elem1[index].to_i <=> elem2[index].to_i)
      break
    else
      next
    end
  end
  result
end

p sorted

# solution 2: The above solution is reinventing the wheel. The sort method already knows how to perform the element-wise comparisons we need, because arrays implement <=>. So the only real problem here is that our inner arrays contain elements of the wrong type, i.e., not the type we want to actually base our comparison on, which is integer. We can sort this out using `map`. For us to only have to do this conversion once, it's best to use sort_by.

result2 = arr.sort_by do |elem|
  elem.map do |elem_of_elem|
    elem_of_elem.to_i
  end
end

p result2
