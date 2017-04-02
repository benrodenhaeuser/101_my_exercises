# given an array of numbers with possible duplicates.
# count how often each element occurs in the array

def count_frequencies(array)
  freq_count = Hash.new { |key,value| key[value] = 0 }
  array.each do |elem|
    freq_count[elem] += 1
  end
  freq_count
end

arr = [0, 1, 2, 2, 4, 4, 4, 6, 6, 6, 6]
p count_frequencies(arr)
