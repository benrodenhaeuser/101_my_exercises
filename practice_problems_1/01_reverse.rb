# Write a method that will take a string as input, and return a new
# string with the same letters in reverse order.
#
# Don't use String's reverse method; that would be too simple.
#
# Difficulty: easy.

# Reverse string non-destructively, returning a copy

def reverse(string)
  reversed = ''
  loop do
    break if string == ''
    reversed << string[-1]
    string = string[0...-1]
  end
  reversed
end

puts("\nTests for #reverse")
puts("===============================================")
    puts(
      'reverse("abc") == "cba": ' + (reverse("abc") == "cba").to_s
    )
    puts(
      'reverse("a") == "a": ' + (reverse("a") == "a").to_s
    )
    puts(
      'reverse("") == "": ' + (reverse("") == "").to_s
    )
puts("===============================================")


# Reverse string in place (destructively)

def reverse!(string)
  index = -2
  loop do
    break if index < -string.size
    value_to_append = string[index]
    string.slice!(index)
    string << value_to_append
    index -= 1
  end
  string
end


puts("\nTests for #reverse!")
puts("===============================================")
    puts(
      'reverse!("abc") == "cba": ' + (reverse!("abc") == "cba").to_s
    )
    puts(
      'reverse!("a") == "a": ' + (reverse!("a") == "a").to_s
    )
    puts(
      'reverse!("") == "": ' + (reverse!("") == "").to_s
    )
puts("===============================================")

p reverse!('abc')
p reverse!('abcd')


# Reverse array in place

def reverse_array!(array)
  index = -2
  loop do
    break if index < -array.size
    value_to_append = array[index]
    array.delete_at(index)
    array << value_to_append
    index -= 1
  end
  array
end


puts("\nTests for #reverse_array!")
puts("===============================================")
    puts(
      'reverse!([1, 2, 3]) == [3, 2, 1]: ' + (reverse_array!([1, 2, 3]) == [3, 2, 1]).to_s
    )
    puts(
      'reverse!([1]) == [1]: ' + (reverse_array!([1]) == [1]).to_s
    )
    puts(
      'reverse!([]) == []: ' + (reverse_array!([]) == []).to_s
    )
puts("===============================================")
