# Exercises: Methods and More Methods

## Exercise 01

```ruby
[1, 2, 3].select do |num|
  num > 5
  'hi'
end
```

The return value is `[1, 2, 3]`


## Exercise 02

```ruby
['ant', 'bat', 'caterpillar'].count do |str|
  str.length < 4
end
```

The return value is `2` (`count` counts the number of elements for which the block returns a true value => see the Ruby docs!).


## Exercise 03

```ruby
[1, 2, 3].reject do |num|
  puts num
end
```

`rejects` returns the elements of the collection on which it is invoked such that the block returns a falsey value (for that element). In our case, the block will return a falsey value on each iteration (namely `nil`), so the return value of the invocation of `reject` is `[1, 2, 3]`.

## Exercise 04

```ruby
['ant', 'bear', 'cat'].each_with_object({}) do |value, hash|
  hash[value[0]] = value
end
```

The return value is `{ 'a' => 'ant', 'b' => 'bear', 'c' => 'cat'}`. `each_with object` returns the object passed to `each_with_object` as an argument, which is, within the block of this method invocation, is referenced by the local variable `hash`. As we can see, on each iteration (of three iterations in total), the block creates a new key-value pair which is saved to the hash `hash`, which is finally returned by `each_with_object`, containing three pairs.  

## Exercise 05

```ruby
hash = { a: 'ant', b: 'bear' }
hash.shift
```

`Hash#shift` removes a key-value pair from the hash on which it is called, and returns that pair as a two-element array, i.e., in this case, `[:a, 'ant']` is returned, and the local variable `hash` now points to the hash `{ b: 'bear'}`.

## Exercise 06

```ruby
['ant', 'bear', 'caterpillar'].pop.size
```

`Array#pop` removes the last element from `self` (i.e., the object on which it is invoked) and returns that element. So in this case, `['ant', 'bear', 'caterpillar'].pop` evaluates to `caterpillar`. The method `String#size` returns the number of characters in the string on which it is called, so, since `caterpillar` has 11 characters, the expression `['ant', 'bear', 'caterpillar'].pop.size` evaluates to 11.

## Exercise 07

```
[1, 2, 3].any? do |num|
  puts num
  num.odd?
end
```

A block returns the object the last evaluated expression in the block evaluates to. So in this case, the block returns whatever `num.odd?` evaluates to, i.e., a boolean (`Integer#odd?` returns true if the integer on which it is called is odd, false otherwise). Here, the return value will be `true` on the first and third iteration, `false` on the second iteration. The invocation of `any?` returns `true`, since there is an element of `[1, 2, 3]` for which the block returns a truthy value (e.g., `1`). The output of the code is `1`, since `any?` stops the iteration as soon as the block has returned `true` once, so `puts num` is only executed once, during the first iteration, when `num` points to `1`.

## Exercise 08

```ruby
arr = [1, 2, 3, 4, 5]
arr.take(2)
```

`Array#take` returns a number of elements from `self`. The number is determined by the argument passed to `take`. In this case, `arr.take(2)` returns `[1, 2]`. The method is non-destructive.

## Exercise 09

```ruby
{ a: 'ant', b: 'bear' }.map do |key, value|
  if value.size > 3
    value
  end
end
```

The return value is `[nil, 'bear']`. This is because `map` uses the return value of the block for transformation. On the first iteration, the conditional expression `if value.size > 3 ... end` (spanning line 2 to 4) returns `nil` (since `value.size > 3` is not a truthy expression, which is because `value` references `ant`, which has less than 4 characters in length). So `nil` becomes the first element of the array that is eventually returned by `map`. On the second iteration, the conditional returns `bear`, so `bear` becomes the second element of the array.

## Exercise 10

```ruby
[1, 2, 3].map do |num|
  if num > 1
    puts num
  else
    num
  end
end
```

The block returns the return value of the branch of the conditional that gets executed, which will be the value of `puts num` if `num > 1` returns a truthy value, or the value of `num` otherwise. So in the first case, the block will return `nil` (any invocation of `puts` returns `nil`), in the second case the block will return the current element of the array (i.e., an integer object).

More concretely: on the first iteration, the block returns `1` (since `1` is not greater than `1` — second branch of conditional is executed), on the second and third iteration, the block returns `nil` (since `2` and `3` are both greater than `1` — first branch of conditional is executed).
