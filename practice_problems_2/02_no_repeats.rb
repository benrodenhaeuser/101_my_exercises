# Write a function, `no_repeats(year_start, year_end)`, which takes a
# range of years and outputs those years which do not have any
# repeated digits.
#
# You should probably write a helper function, `no_repeat?(year)` which
# returns true/false if a single year doesn't have a repeat.
#
# Difficulty: 1/5

=begin

APPROACH

1) requirements:

  - given argument: a range (of positive integers)
  - return value: array containing integers within the range whose digits do not repeat

2) example:

  given (1..11)
  return [1, 2, ..., 10]
  (11 has repeating digit, so should not be returned as part of array)

3) algo:

  - helper method `no_repeat?`: given positive integer, does integer have repetitions? (return true/false, i.e., a test)

  - assuming method no_repeat? is available:
    - iterate over the range (using block argument `number`)
      - append numbers such that no_repeat?(number) to new array
    - return that new array

  - how to do the helper method?

    - given number
    - split number to array of digits
    - iterate over array of digits:
      - if element has been seen before, return false
      - record that element has been seen
    - return true (if we are at this point, there have been no reps!)

=end

def no_repeat?(number)
  digits = number.to_s.chars
  seen = []
  digits.each do |digit|
    return false if seen.include?(digit)
    seen << digit
  end
  true
end

def no_repeats(year_start, year_end)
  unrepeateds = []
  (year_start..year_end).each do |year|
    unrepeateds << year if no_repeat?(year)
  end
  unrepeateds
end

puts("\nTests for #no_repeats")
puts("===============================================")
    puts "no_repeats(1234, 1234) == [1234]: "  + (no_repeats(1234, 1234) == [1234]).to_s
    puts "no_repeats(1123, 1123) == []: "  + (no_repeats(1123, 1123) == []).to_s
    puts "no_repeats(1980, 1987) == [1980,1982,1983,1984,1985,1986,1987]: " + (no_repeats(1980, 1987) == [1980,1982,1983,1984,1985,1986,1987]).to_s
puts("===============================================")
