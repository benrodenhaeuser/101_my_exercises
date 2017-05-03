# Write a function, `letter_count(str)` that takes a string and
# returns a hash mapping each letter to its frequency. Do not include
# spaces.
#
# Difficulty: 1/5

=begin

approach

1) requirements

  - input argument: string
  - return value: hash
  - hash represents, for each letter occuring in string, the number of occurences of letter in string (e.g., might contain a pair `'a' => 2` to indicate that there are two 'a's in the string)
  - do not include spaces in count!

2) examples

  - empty string input? return empty hash
  - given string 'anna', want to return
      { 'a' => 2, 'n' => 2 }

3) algorithm

  - given our input string
  - initialize empty hash to hold our letter counts
  - uninitialized hash keys should return 0 (i.e., for a key that is not in the hash, hash[key] should evaluate to 0)
  - iterate over the chars in string:
    - increase count for each char we see
  - return hash

=end

# solution 1

def letter_count(str)
  counts = Hash.new { |hash, key| hash[key] = 0 }
  str.chars.each do |char|
    next if char == ' '
    counts[char] += 1
  end
  counts
end

# solution 2: ignore whitespace as we split to string

def letter_count(str)
  counts = Hash.new { |hash, key| hash[key] = 0 }
  str.split(/ |/).each do |char|
    counts[char] += 1
  end
  counts
end

# solution 3: with a plain hash that returns `nil` if key does not exist in hash

def letter_count(str)
  counts = { }
  str.split(/ |/).each do |char|
    if counts[char]
      counts[char] += 1
    else
      counts[char] = 1
    end
  end
  counts
end

# tests


puts("\nTests for #letter_count")
puts("===============================================")
    puts "letter_count(\"cat\") == {\"c\" => 1, \"a\" => 1, \"t\" => 1}: "  + (letter_count("cat") == {"c" => 1, "a" => 1, "t" => 1}).to_s
    puts "letter_count(\"moon\") == {\"m\" => 1, \"o\" => 2,\"n\" => 1}: "  + (letter_count("moon") == {"m" => 1, "o" => 2,"n" => 1}).to_s
    puts "letter_count(\"cats are fun\") == {\"a\" => 2, \"c\" => 1, \"e\"=> 1, \"f\" => 1, \"n\" => 1, \"r\" => 1, \"s\" => 1, \"t\" => 1, \"u\" => 1}: "  + (letter_count("cats are fun") == {"a" => 2, "c" => 1, "e"=> 1, "f" => 1, "n" => 1, "r" => 1, "s" => 1, "t" => 1, "u" => 1}).to_s
puts("===============================================")
