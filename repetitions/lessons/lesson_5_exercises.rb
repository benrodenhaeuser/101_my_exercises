# Exercise 1

# order array by descending numerical value

arr = ['10', '11', '9', '7', '8']
result = arr.sort_by { |elem| elem.to_i }

# Exercise 2

# Order array of hashes based on the year of publication of each book, from the earliest to the latest?

books = [
  {title: 'One Hundred Years of Solitude', author: 'Gabriel Garcia Marquez', published: '1967'},
  {title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', published: '1925'},
  {title: 'War and Peace', author: 'Leo Tolstoy', published: '1869'},
  {title: 'Ulysses', author: 'James Joyce', published: '1922'}
]

result = books.sort_by { |book| book[:published]  }

# Exercise 3

# Reference the value 'g'

arr1 = ['a', 'b', ['c', ['d', 'e', 'f', 'g']]]

arr1[2][1][3]

arr2 = [{first: ['a', 'b', 'c'], second: ['d', 'e', 'f']}, {third: ['g', 'h', 'i']}]

arr2[1][:third][0]

arr3 = [['abc'], ['def'], {third: ['ghi']}]

arr3[2][:third][0][0]

hsh1 = {'a' => ['d', 'e'], 'b' => ['f', 'g'], 'c' => ['h', 'i']}

hsh1['b'][1]

hsh2 = {first: {'d' => 3}, second: {'e' => 2, 'f' => 1}, third: {'g' => 0}}

hsh2[:third].keys[0] # the first element of the array of keys
hsh2[:third].key(0) # the key of (the first occurence of the value) 0

# Exercise 4

# Increment 3 to 4

arr1 = [1, [2, 3], 4]
arr1[1][1] = 4
arr1 # [1, [2, 4], 4]

arr2 = [{a: 1}, {b: 2, c: [7, 6, 5], d: 4}, 3]
arr2[2] += 1
arr2 # [{a: 1}, {b: 2, c: [7, 6, 5], d: 4}, 4]

hsh1 = {first: [1, 2, [3]]}
hsh1[:first][2][0] += 1
hsh1 # {:first=>[1, 2, [4]]}

hsh2 = {['a'] => {a: ['1', :two, 3], b: 4}, 'b' => 5}
hsh2[['a']][:a][2] += 1
hsh2 # {['a'] => {a: ['1', :two, 4], b: 4}, 'b' => 5}

# Exercise 5

# Figure out the total age of just the male members of the family.

munsters = {
  "Herman" => { "age" => 32, "gender" => "male" },
  "Lily" => { "age" => 30, "gender" => "female" },
  "Grandpa" => { "age" => 402, "gender" => "male" },
  "Eddie" => { "age" => 10, "gender" => "male" },
  "Marilyn" => { "age" => 23, "gender" => "female"}
}

# approach 1: "select the male munsters, map to their ages, and sum up"
total_age = munsters.select { |_, value| value['gender'] == 'male'  }.map { |_, value| value['age'] }.reduce(&:+)

total_age # 444

# approach 2: "for each munster, add munster's age to total_value if munster is male"

total_age = 0
munsters.each do |key, value|
  total_age += value['age'] if value['gender'] == 'male'
end
total_age # 444

# Exercise 6

# print out the name, age and gender of each family member in the format "(Name) is a (age)-year-old (male or female)."

munsters = {
  "Herman" => { "age" => 32, "gender" => "male" },
  "Lily" => { "age" => 30, "gender" => "female" },
  "Grandpa" => { "age" => 402, "gender" => "male" },
  "Eddie" => { "age" => 10, "gender" => "male" },
  "Marilyn" => { "age" => 23, "gender" => "female"}
}

# munsters.each do |name, details|
#   puts "#{name} is a #{details['age']}-year old #{details['gender']}"
# end

# Exercise 7

# What are the final values of a and b?

a = 2
b = [5, 8]
arr = [a, b]

arr[0] += 2
arr[1][0] -= a

a == 2 # => true
b == [3, 8] # => true

# Exercise 8

# Using the each method, write some code to output all of the vowels from the strings.

hsh = {first: ['the', 'quick'], second: ['brown', 'fox'], third: ['jumped'], fourth: ['over', 'the', 'lazy', 'dog']}

# hsh.each_value do |value|
#   value.each do |str|
#     str.chars.each do |char|
#       puts char if %w(a e i o u).include?(char)
#     end
#   end
# end

# Exercise 9

# Given the following data structure, return a new array of the same structure but with the sub arrays being ordered (alphabetically or numerically as appropriate) in descending order.

arr = [['b', 'c', 'a'], [2, 1, 3], ['blue', 'black', 'green']]

arr.map do |elem|
  elem.sort { |elem_elem1, elem_elem2| elem_elem2 <=> elem_elem1 }
end

# => [["c", "b", "a"], [3, 2, 1], ["green", "blue", "black"]]

# Exercise 10

# Given the following data structure and *without modifying the original array*, use the map method to return a new array identical in structure to the original but where the value of each integer is incremented by 1.

[{a: 1}, {b: 2, c: 3}, {d: 4, e: 5, f: 6}].map do |hash|
  incremented_hash = {}
  hash.each_key { |key| incremented_hash[key] = hash[key] + 1 }
  incremented_hash
end

# => [{:a=>2}, {:b=>3, :c=>4}, {:d=>5, :e=>6, :f=>7}]

# Exercise 11

# Given the following data structure use a combination of methods, including either the select or reject method, to return a new array identical in structure to the original but containing only the integers that are multiples of 3.

arr = [[2], [3, 5, 7], [9], [11, 13, 15]]

result = arr.map do |sub_arr|
  sub_arr.select do |number|
    number % 3 == 0
  end
end

result # [[], [3], [9], [15]]

# Exercise 12

# Given the following data structure, and without using the Array#to_h method, write some code that will return a hash where the key is the first item in each sub array and the value is the second item.

arr = [[:a, 1], ['b', 'two'], ['sea', {c: 3}], [{a: 1, b: 2, c: 3, d: 4}, 'D']]

hash = {}

arr.each do |sub_arr|
  hash[sub_arr[0]] = sub_arr[1]
end

hash # => {:a=>1, "b"=>"two", "sea"=>{:c=>3}, {:a=>1, :b=>2, :c=>3, :d=>4}=>"D"}

# Exercise 13

# Given the following data structure, return a new array containing the same sub-arrays as the original but ordered logically according to the numeric value of the odd integers they contain.

arr = [[1, 6, 7], [1, 4, 9], [1, 8, 3]]

# The sorted array should look like this:
# [[1, 8, 3], [1, 6, 7], [1, 4, 9]]

# [1, 8, 3] comes before [1, 6, 7] because 3 precedes 7
# [1, 6, 7] comes before [1, 4, 9] because 7 precedes 9

# select from arrays the odds and use the "odds arrays" as sort keys (i.e., rely on the sorting ability built into `Array#<=>`)

arr.sort_by do |elem|
  elem.select do |number|
    number.odd?
  end
end

# => [[1, 8, 3], [1, 6, 7], [1, 4, 9]]

# Exercise 14

# Given this data structure write some code to return an array containing the colors *of the fruits* and the sizes *of the vegetables*. *The sizes should be uppercase and the colors should be capitalized.*

hsh = {
  'grape' => {type: 'fruit', colors: ['red', 'green'], size: 'small'},
  'carrot' => {type: 'vegetable', colors: ['orange'], size: 'medium'},
  'apple' => {type: 'fruit', colors: ['red', 'green'], size: 'medium'},
  'apricot' => {type: 'fruit', colors: ['orange'], size: 'medium'},
  'marrow' => {type: 'vegetable', colors: ['green'], size: 'large'},
}

# first (wrong) solution: this misses the fact that we want colors of fruits only and sizes of vegetables only!

hsh.flat_map do |_, value|
  [value[:colors].map { |color| color.capitalize }, value[:size].upcase]
end
# [["Red", "Green"], "SMALL", ["Orange"], "MEDIUM", ["Red", "Green"], "MEDIUM", ["Orange"], "MEDIUM", ["Green"], "LARGE"]

# second (correct) solution

hsh.map do |_, value|
  if value[:type] == 'fruit'
    value[:colors].map { |color| color.capitalize }
  elsif value[:type] == 'vegetable'
    value[:size].upcase
  end
end
# => [["Red", "Green"], "MEDIUM", ["Red", "Green"], ["Orange"], "LARGE"]

# Exercise 15

# Given this data structure write some code to return an array which contains only the hashes where all the integers are even.

arr = [{a: [1, 2, 3]}, {b: [2, 4, 6], c: [3, 6], d: [4]}, {e: [8], f: [6, 10]}]

arr.select do |hash|
  hash.all? do |_, value|
    value.all? do |number|
      number.even?
    end
  end
end
# => # => [{:e=>[8], :f=>[6, 10]}]

# Exercise 16

def generate_UUID
  characters = ('0'..'9').to_a + ('a'..'f').to_a
  sections = [8, 4, 4, 4, 12]
  part_strings = sections.map do |section|
    part_string = ''
    section.times { part_string << characters.sample }
    part_string
  end
  part_strings.join('-')
end

generate_UUID # => "6f256e0f-1ffa-1ceb-ce60-c2560d2025e8"
