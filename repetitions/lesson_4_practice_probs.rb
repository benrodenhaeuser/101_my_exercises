# Lesson 04 Additional Practice Problems

# Practice Problem 01

flintstones = ["Fred", "Barney", "Wilma", "Betty", "Pebbles", "BamBam"]

# Turn this array into a hash where the names are the keys and the values are the positions in the array.

flint_hash = {}
flintstones.each_with_index do |person, index|
  flint_hash[person] = index
end

p flint_hash

# Practice Problem 02

ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 5843, "Eddie" => 10, "Marilyn" => 22, "Spot" => 237 }

# Add up all of the ages from the Munster family hash

p ages.values.inject(&:+)

# or:

total = 0
ages.each do |_, age|
  total += age
end
p total

# Practice Problem 03

ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 402, "Eddie" => 10 }

# throw out the really old people (age 100 or older)

ages.reject! do |person, _|
  ages[person] > 100
end

p ages

# Practice Problem 04

ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 5843, "Eddie" => 10, "Marilyn" => 22, "Spot" => 237 }

# Pick out the minimum age from our current Munster family hash

p ages.values.min

# Practice Problem 05

flintstones = %w(Fred Barney Wilma Betty BamBam Pebbles)

# Find the index of the first name that starts with "Be"

# with a loop:

index = 0
first_with_be = loop do
  break nil if index >= flintstones.length
  break index if flintstones[index].start_with?('Be')
  index += 1
end
p first_with_be

# with Array method 'index':
flintstones.index { |elem| elem.start_with?('Be') }

# or:
flintstones.index { |elem| elem[0, 2] == 'Be'}

# Practice Problem 06

flintstones = %w(Fred Barney Wilma Betty BamBam Pebbles)

# Amend the array so that the names are all shortened to just the first three characters

flintstones.each { |elem| elem.slice!(3...elem.size) }

p flintstones

# Practice Problem 07

statement = "The Flintstones Rock"

# Create a hash that expresses the frequency with which each letter occurs in this string

freq = Hash.new { |hash, key| hash[key] = 0 }
statement.chars.each do |char|
  freq[char] += 1
end

p freq

# Practice Problem 08

numbers = [1, 2, 3, 4]
numbers.each do |number|
  p number
  numbers.shift(1)
end

# What would be output by the above code?

# ===> 1, 3

numbers = [1, 2, 3, 4]
numbers.each do |number|
  p number
  numbers.pop(1)
end

# What would be output by the above code?

# ===> 1, 2


# Practice Problem 09

# Write a method :titleize that titleizes a string, i.e., it capitalizes each word of the string

def titleize(sentence)
  sentence.split(' ').map { |word| word.capitalize }.join(' ')
end

p titleize('the flintstones rock')

# Practice Problem 10

munsters = {
  "Herman" => { "age" => 32, "gender" => "male" },
  "Lily" => { "age" => 30, "gender" => "female" },
  "Grandpa" => { "age" => 402, "gender" => "male" },
  "Eddie" => { "age" => 10, "gender" => "male" },
  "Marilyn" => { "age" => 23, "gender" => "female"}
}

# Modify the hash such that each member of the Munster family has an additional "age_group" key that has one of three values describing the age group the family member is in (kid, adult, or senior). Your solution should produce the hash below.

# Criterion:
# - a kid is in the age range 0 - 17,
# - an adult is in the range 18 - 64
# - a senior is aged 65+.

munsters.each do |person, _|
  if munsters[person]['age'] <= 17
    munsters[person]['age_group'] = 'kid'
  elsif munsters[person]['age'] <= 64
    munsters[person]['age_group'] = 'adult'
  else
    munsters[person]['age_group'] = 'senior'
  end
end

p munsters


# using case statement and range
munsters.each do |person, details|
  case details['age']
  when (0..17)
    details['age_group'] = 'kid'
  when (18..64)
    details['age_group'] = 'adult'
  else
    details['age_group'] = 'senior'
  end
end
