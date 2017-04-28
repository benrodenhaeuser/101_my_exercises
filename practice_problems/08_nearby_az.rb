# Write a method that takes a string in and returns true if the letter
# "z" appears within three letters **after** an "a". You may assume
# that the string contains only lowercase letters.
#
# Difficulty: medium.


# regex:

def nearby_az(string)
  !!string.match(/a.{0,2}z/)
end

# with a loop

def nearby_az(string)

  scanning_for_z = false

    string.chars.each do |char|
      if scanning_for_z && char == 'z'
        return true
      elsif scanning_for_z
        scanning_for_z -= 1
      end

      if char == 'a'
        scanning_for_z = 2
      end

      if scanning_for_z == 0
        scanning_for_z = false
      end

    end

  return false

end

# with two nested loops

def nearby_az(string)
  index1 = 0
  loop do
    break if index1 >= string.size
    if string[index1] != 'a'
      index1 += 1
      next
    end

    # if we got here, we have just hit an `a`

    index2 = index1 + 1
    loop do
      break if index2 > index1 + 3
      return true if string[index2] == 'z'
      index2 += 1
    end

    index1 += 1
  end

  false
end


puts("\nTests for #nearby_az")
puts("===============================================")
    puts('nearby_az("baz") == true: ' + (nearby_az('baz') == true).to_s)
    puts('nearby_az("abz") == true: ' + (nearby_az('abz') == true).to_s)
    puts('nearby_az("abcz") == true: ' + (nearby_az('abcz') == true).to_s)
    puts('nearby_az("a") == false: ' + (nearby_az('a') == false).to_s)
    puts('nearby_az("z") == false: ' + (nearby_az('z') == false).to_s)
    puts('nearby_az("za") == false: ' + (nearby_az('za') == false).to_s)
puts("===============================================")

# how exactly is the distance between a and z defined?
# I interpret it like this:
p nearby_az("bariz") == true
p nearby_az("barioz") == false
