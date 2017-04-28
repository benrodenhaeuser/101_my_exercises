# Write a method that takes in a number and returns a string, placing
# a single dash before and after each odd digit. There is one
# exception: don't start or end the string with a dash.
#
# You may wish to use the `%` modulo operation; you can see if a number
# is even if it has zero remainder when divided by two.
#
# Difficulty: medium.

=begin

APPROACH

- split num.to_i into an array of chars
- initialize a new empty array dasherized
- iterate over the array of chars with each:

  in each iteration, do the following:

  if (the current char is odd or the next char is odd) and current char is not the last one
    push '-' and char to new array
  else
    push char to new array
  end

- join the new array

=end

def dasherize_number(num)
  chars = num.to_s.chars
  dasherized = []
  chars.each_with_index do |char, index|
      if (chars[index].to_i.odd? || chars[index + 1].to_i.odd?) && index + 1 != chars.size
        dasherized << char + '-'
      else
        dasherized << char
      end
  end
  dasherized.join
end

puts("\nTests for #dasherize_number")
puts("===============================================")
    puts(
      'dasherize_number(203) == "20-3": ' +
      (dasherize_number(203) == '20-3').to_s
    )
    puts(
      'dasherize_number(303) == "3-0-3": ' +
      (dasherize_number(303) == '3-0-3').to_s
    )
    puts(
      'dasherize_number(333) == "3-3-3": ' +
      (dasherize_number(333) == '3-3-3').to_s
    )
    puts(
      'dasherize_number(3223) == "3-22-3": ' +
      (dasherize_number(3223) == '3-22-3').to_s
    )
puts("===============================================")
