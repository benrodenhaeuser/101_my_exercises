# Easy 1

## Question 2

- `!=` is an operator that takes two arguments and returns true iff the two arguments do not evaluate to objects with the same value. For example if the local variable `a` points to the integer `5`, and the local variable `b` points to the integer `7`, then `a != b` evaluates to `true`. On the other hand, suppose we have two distinct string objects, both with value `test`. Suppose further that the local variables `a` and `b` point to these distinct string objects. Then `a != b` will evaluate to `false`, because both local variables point to objects that, while distinct, have the same value.
- `!user_name` returns `false` if `user_name` is truthy, and `true` if `user_name` is falsey. More generally, the `!` operator takes one argument and returns `true` if its argument is falsey, `false` if its argument is truthy. Another way to say this is that `!a` yields the opposite of the Boolean equivalent of `a`, given a Ruby expression `a`.
- The bang `!` may be used as the last character in a method name, e.g., `uniq!`, `slice!` etc. By convention, using the bang in this way indicates that the method is "dangerous" in some way, more specifically, it often (but not always) indicates that the method is destructive, i.e., mutates the calling object.
- The ternary operator in Ruby is a brief notation equivalent to an `if ... else ... end` conditional. Given Ruby expressions `a`, `b` and `c`, `a ? b : c` is a conditional with two branches, `b` and `c`. The `b`-branch is executed if `a` is truthy, and the `c`-branch is executed if `a` is falsey.
- The `?` may be used as the last character in a method name. It indicates that the method is used as a test. Typically, such methods will return a Boolean object (`true` or `false`), but this need not be the case. For example, the `defined?` operator (which is not a method) returns `nil` if the argument passed is not defined, and a string description of its argument otherwise (e.g., "local-variable"). Note, however that this will work as expected in a Boolean context (e.g., `if defined? ...`).
- Applying unary negation twice yields the truthiness of the argument *as a truth-value*. More precisely, `!!a` evaluates to `true` iff `a` is truthy, to `false` iff `a` is falsey (where `a` is a Ruby expression). Another way to say this is that `!!a` yields the Boolean equivalent of `a`.

## Question 3

```ruby
advice = "Few things in life are as important as house training your pet dinosaur."
words_of_advice = advice.split
words_of_advice[6] = 'urgent'
advice = words_of_advice.join(' ')
```

Or more simply:

```ruby
advice.gsub!('important', 'urgent')
```

## Question 4

```ruby
numbers.delete_at(1)
numbers.delete(1)
```

`Array#delete_at` deletes the element at the index given as an argument.
`Array#delete` deletes the value given as an argument.

## Question 5


```ruby
(0..100).include?(42)
```

(or use `cover?`, which is equivalent to `include?` for ranges)

## Question 6

```ruby
famous_words = "seven years ago..."
famous_words.prepend('four score and ')

famous_words = "seven years ago..."
famous_words = 'four score and '.concat(famous_words)
```

# Easy 2

## Exercise 1

```ruby
ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 402, "Eddie" => 10 }
ages.keys.include?('Spot')
ages.member?('Spot')
ages.key?('Spot')
```

## Exercise 2

```ruby
description = "The Munsters are creepy in a good way."
description.downcase!.capitalize!
description == "The munsters are creepy in a good way."

description = "The Munsters are creepy in a good way."
description.swapcase!
description == "tHE mUNSTERS ARE CREEPY IN A GOOD WAY."

description = "The Munsters are creepy in a good way."
description.downcase!
description == "the munsters are creepy in a good way."

description = "The Munsters are creepy in a good way."
description.upcase!
description == "THE MUNSTERS ARE CREEPY IN A GOOD WAY."
```

## Exercise 3

```ruby
ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 5843, "Eddie" => 10 }
additional_ages = { "Marilyn" => 22, "Spot" => 237 }
ages.merge!(additional_ages)
```

## Exercise 4

```ruby
advice = "Few things in life are as important as house training your pet dinosaur."
!!advice.match('dino')
```

## Exercise 5

```ruby
flintstones = ["Fred", "Barney", "Wilma", "Betty", "BamBam", "Pebbles"]
flintstones = %w[Fred Barney Wilma Betty BamBam Pebbles]
```

## Exercise 6

```ruby
flintstones = %w(Fred Barney Wilma Betty BamBam Pebbles)
flintstones << 'Dino'
```

## Exercise 7

```ruby
(flintstones << 'dino') << 'hoppy'
flintstones.concat(['dino', 'hoppy'])
```

## Exercise 8

```ruby
advice = "Few things in life are as important as house training your pet dinosaur."
advice.slice!(0..37) # => "Few things in life are as important as"
advice # => " house training your pet dinosaur."
```

## Exercise 9

```ruby
statement = "The Flintstones Rock!"
statement.scan(/[a-z]/).size # => 15 (number of lowercase characters)
statement.count('t') # => 2 (number of 't's)
```

## Exercise 10

title = 'Flintstone Family Members'
title = title.center(40)


# Medium 01

## Exercise 01

```ruby
10.times { |index| puts (' ' * index) + 'The Flintstones rock' }
```

## Exercise 03

```ruby
def factors(number)
  dividend = number
  divisors = []
  while dividend > 0
    divisors << number / dividend if number % dividend == 0
    dividend -= 1
  end
  divisors
end
```

# Medium 02

## Question 01

```ruby
def fun_with_ids
  a_outer = 42 # A
  b_outer = "forty two" # B
  c_outer = [42] # C
  d_outer = c_outer[0] # D

  a_outer_id = a_outer.object_id # A
  b_outer_id = b_outer.object_id # B
  c_outer_id = c_outer.object_id # C
  d_outer_id = d_outer.object_id # D

  puts "a_outer is #{a_outer} with an id of: #{a_outer_id} before the block."
  puts "b_outer is #{b_outer} with an id of: #{b_outer_id} before the block."
  puts "c_outer is #{c_outer} with an id of: #{c_outer_id} before the block."
  puts "d_outer is #{d_outer} with an id of: #{d_outer_id} before the block.\n\n"

  1.times do
    a_outer_inner_id = a_outer.object_id # A
    b_outer_inner_id = b_outer.object_id # B
    c_outer_inner_id = c_outer.object_id # C
    d_outer_inner_id = d_outer.object_id # D

    puts "a_outer id was #{a_outer_id} before the block and is: #{a_outer_inner_id} inside the block."
    puts "b_outer id was #{b_outer_id} before the block and is: #{b_outer_inner_id} inside the block."
    puts "c_outer id was #{c_outer_id} before the block and is: #{c_outer_inner_id} inside the block."
    puts "d_outer id was #{d_outer_id} before the block and is: #{d_outer_inner_id} inside the block.\n\n"

    a_outer = 22 # F
    b_outer = "thirty three" # G
    c_outer = [44] # H
    d_outer = c_outer[0] # I

    puts "a_outer inside after reassignment is #{a_outer} with an id of: #{a_outer_id} before and: #{a_outer.object_id} after."
    puts "b_outer inside after reassignment is #{b_outer} with an id of: #{b_outer_id} before and: #{b_outer.object_id} after."
    puts "c_outer inside after reassignment is #{c_outer} with an id of: #{c_outer_id} before and: #{c_outer.object_id} after."
    puts "d_outer inside after reassignment is #{d_outer} with an id of: #{d_outer_id} before and: #{d_outer.object_id} after.\n\n"

    a_inner = a_outer # F
    b_inner = b_outer # G
    c_inner = c_outer # H
    d_inner = c_inner[0] # I

    a_inner_id = a_inner.object_id # F  
    b_inner_id = b_inner.object_id # G
    c_inner_id = c_inner.object_id # H
    d_inner_id = d_inner.object_id # I

    puts "a_inner is #{a_inner} with an id of: #{a_inner_id} inside the block (compared to #{a_outer.object_id} for outer)."
    puts "b_inner is #{b_inner} with an id of: #{b_inner_id} inside the block (compared to #{b_outer.object_id} for outer)."
    puts "c_inner is #{c_inner} with an id of: #{c_inner_id} inside the block (compared to #{c_outer.object_id} for outer)."
    puts "d_inner is #{d_inner} with an id of: #{d_inner_id} inside the block (compared to #{d_outer.object_id} for outer).\n\n"
  end

  puts "a_outer is #{a_outer} with an id of: #{a_outer_id} BEFORE and: #{a_outer.object_id} AFTER the block."
  puts "b_outer is #{b_outer} with an id of: #{b_outer_id} BEFORE and: #{b_outer.object_id} AFTER the block."
  puts "c_outer is #{c_outer} with an id of: #{c_outer_id} BEFORE and: #{c_outer.object_id} AFTER the block."
  puts "d_outer is #{d_outer} with an id of: #{d_outer_id} BEFORE and: #{d_outer.object_id} AFTER the block.\n\n"

  puts "a_inner is #{a_inner} with an id of: #{a_inner_id} INSIDE and: #{a_inner.object_id} AFTER the block." rescue puts "ugh ohhhhh"
  puts "b_inner is #{b_inner} with an id of: #{b_inner_id} INSIDE and: #{b_inner.object_id} AFTER the block." rescue puts "ugh ohhhhh"
  puts "c_inner is #{c_inner} with an id of: #{c_inner_id} INSIDE and: #{c_inner.object_id} AFTER the block." rescue puts "ugh ohhhhh"
  puts "d_inner is #{d_inner} with an id of: #{d_inner_id} INSIDE and: #{d_inner.object_id} AFTER the block.\n\n" rescue puts "ugh ohhhhh"
end
```

## Question 03

```ruby
def tricky_method(a_string_param, an_array_param)
  a_string_param += "rutabaga"
  an_array_param << "rutabaga"
end

my_string = "pumpkins"
my_array = ["pumpkins"]
tricky_method(my_string, my_array)

puts "My string looks like this now: #{my_string}"
# => 'pumpkins'
puts "My array looks like this now: #{my_array}"
# => '['pumpkins', 'rutabaga']'
```

The method `tricky_method` takes two arguments, a string and an array. As the arguments are passed into the method, the objects they reference are assigned to the two method parameters, `a_string_param` and `an_array_param`. Within the method, the object referenced by `an_array_param` is mutated (by the call to `Array#<<`, which is a destructive method). But the object referenced by `a_string_param` is not mutated (the only method called on `a_string_param` is `+`, but `String#+` is not destructive). Since the object referenced by `an_array_param` is the same object that is also referenced by the local variable `my_array` outside, `my_array` will reference the array object `[`pumpkins`, `rutabaga`]` by the time it is `puts`ed.

## Question 04

```ruby
def tricky_method_two(a_string_param, an_array_param)
  a_string_param << 'rutabaga'
  an_array_param = ['pumpkins', 'rutabaga']
end

my_string = "pumpkins"
my_array = ["pumpkins"]
tricky_method_two(my_string, my_array)

puts "My string looks like this now: #{my_string}"
puts "My array looks like this now: #{my_array}"
```

In this example, it is the string object referenced by `my_string` that is mutated, while the array object referenced by `my_array` is not mutated. Within the method, the local variable `an_array_param`, which is initially bound to the array object, is reassigned to a new array. But reassignment does not affect the object to which a variable points before the reassignment.


## Question 05

```ruby
def color_valid(color)
  if color == "blue" || color == "green"
    true
  else
    false
  end
end
```

Simplified:

```ruby
def color_valid(color)
  color == 'blue' || color == 'green'
end
```

The expression `color == 'blue' || color == 'green'` will return `true` if at least one of its arguments evaluates to the object `true`, and `false` otherwise. But this is just what we want! So the expression is actually completely equivalent to the `if ... then ... end` conditional!

# Hard 01


## Question 01

```ruby
if false
  greeting = “hello world”
end

greeting
```

`greeting` points to `nil`.

## Question 02

```ruby
greetings = { a: 'hi' }
informal_greeting = greetings[:a]
informal_greeting << ' there'

puts informal_greeting  #  => "hi there"
puts greetings
```

The output is `{ a: 'hi there' }`.

## Question 03

```ruby
def mess_with_vars(one, two, three)
  one = two
  two = three
  three = one
end

one = "one"
two = "two"
three = "three"

mess_with_vars(one, two, three)

puts "one is: #{one}"
puts "two is: #{two}"
puts "three is: #{three}"
```

`one is: one`, `two is: two`, `three is: three`


```ruby
def mess_with_vars(one, two, three)
  one = "two"
  two = "three"
  three = "one"
end

one = "one"
two = "two"
three = "three"

mess_with_vars(one, two, three)

puts "one is: #{one}"
puts "two is: #{two}"
puts "three is: #{three}"
```

`one is: one`, `two is: two`, `three is: three`

```ruby
def mess_with_vars(one, two, three)
  one.gsub!("one","two")
  two.gsub!("two","three")
  three.gsub!("three","one")
end

one = "one"
two = "two"
three = "three"

mess_with_vars(one, two, three)

puts "one is: #{one}"
puts "two is: #{two}"
puts "three is: #{three}"
```

`one is: two`, `two is: three`, `three is: one`


## Question 04

```ruby
def dot_separated_ip_address?(input_string)
  dot_separated_words = input_string.split(".")
  return false unless dot_separated_words.size == 4
  while dot_separated_words.size > 0 do
    word = dot_separated_words.pop
    return false unless is_an_ip_number?(word)
  end
  return true
end
```
