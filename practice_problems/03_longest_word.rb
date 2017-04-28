# Write a method that takes in a string. Return the longest word in
# the string. You may assume that the string contains only letters and
# spaces.
#
# You may use the String `split` method to aid you in your quest.
#
# Difficulty: easy.

# with each

def longest_word(sentence)
  longest = ''
  sentence.split.each { |word| longest = word if word.length > longest.length }
  longest
end

# with a loop

def longest_word(sentence)
  longest = ''
  words = sentence.split
  index = 0
  loop do
    break if index >= words.length
    current_word = words[index]
    longest = current_word if current_word.length > longest.length
    index += 1
  end
  longest
end

puts("\nTests for #longest_word")
puts("===============================================")
    puts(
      'longest_word("short longest") == "longest": ' +
      (longest_word('short longest') == 'longest').to_s
    )
    puts(
      'longest_word("one") == "one": ' +
      (longest_word('one') == 'one').to_s
    )
    puts(
      'longest_word("abc def abcde") == "abcde": ' +
      (longest_word('abc def abcde') == 'abcde').to_s
    )
puts("===============================================")
