# interleave two non-empty arrays of the same length

def interleave(array1, array2)
  interleaved = []
  array1.each_index do |index|
    interleaved << array1[index]
    interleaved << array2[index]
  end
  interleaved
end

array1 = [1, 2, 3, 4]
array2 = %w[a b c d]

p interleave(array1, array2)

# [1, "a", 2, "b", 3, "c", 4, "d"]
