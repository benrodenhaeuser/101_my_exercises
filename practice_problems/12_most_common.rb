# Write a method that takes in a string. Your method should return the
# most common letter in the array, and a count of how many times it
# appears.
#
# Difficulty: medium.

def most_common_letter(string)
  frequency_counts = Hash.new { |hash, key| hash[key] = 0 }
  string.chars.each { |char| frequency_counts[char] += 1 }
  max_value = frequency_counts.values.max
  frequency_counts.select { |_, count| count == max_value }.to_a.first
end

p most_common_letter('abca')


puts("\nTests for #most_common_letter")
puts("===============================================")
    puts(
      'most_common_letter("abca") == ["a", 2]: ' +
      (most_common_letter('abca') == ['a', 2]).to_s
    )
    puts(
      'most_common_letter("abbab") == ["b", 3]: ' +
      (most_common_letter('abbab') == ['b', 3]).to_s
    )
puts("===============================================")
