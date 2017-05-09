# Working with Blocks

- What is the *type of action* being performed (method call, block, conditional, etc..)?
- What is the *object* that action is being performed on?
- What is the *side-effect* of that action (e.g. output or destructive action)?
- What is the *return value* of that action?
- Is the return value *used* by whatever instigated the action?

## Example 1

	[[1, 2], [3, 4]].each do |arr|
	  puts arr.first
	end
	# 1
	# 3
	# => [[1, 2], [3, 4]]

In line 1, the `each` method is invoked on the two-dimensional array `[[1, 2], [3, 4]]`. Along with the method invocation, a block is passed to `each` which is executed once for every element of the array (the block spans from line 1 to line 3 and is demarcated by the keywords `do...end`. During each execution of the blcok, the current array element (itself an array) is assigned to the block parameter `arr`. Then, the `Array#first` method is called on `arr`, returning the first element of `arr` (on line 4). This first element is (converted to a string and) printed to stdout, as a result of the invocation of the `Kernel#puts` method with argument `arr.first` (still on line 4). Tying all this together, the two iterations of the block print (string representations of) 1 and 3, respectively, as these are, respectively, the first elements of `[1, 2]` and `[3, 4]`. The return value of the block is `nil` on each iteration, since this is the return value of the `puts` invocation, which is the last evaluated expression within the block. However, this return value is not used by the `each` method. The return value of the `each` invocation is the object it is called on, in this case, the array `[[1, 2], [3, 4]]` (this ultimate return value is shown on line 6). *(1235 characters)*

*Instructor description:*

The Array#each method is being called on the multi-dimensional array `[[1, 2], [3, 4]]`. Each inner array is passed to the block in turn and assigned to the local variable `arr`. The `Array#first` method is called on `arr` and returns the object at index `0` of the current array - in this case the integers `1` and `3`, respectively. The `puts` method then outputs a string representation of the integer. `puts` returns `nil` and, since this is the last evaluated statement within the block, the return value of the block is therefore `nil`. `each` doesn't do anything with this returned value though, and since the return value of `each` is the calling object - in this case the nested array `[[1, 2], [3, 4]]` - this is what is ultimately returned. *(723 characters)*

## Example 2

	[[1, 2], [3, 4]].map do |arr|
	  puts arr.first
	end
	# 1
	# 3
	# => [nil, nil]

On line 1, the `map` method is called on the two-dimensional array `[[1, 2], [3, 4]]`. `map` is an iterator method, so the block that is passed along with the method invocation (spanning from line 1 to line 3, demarcated by the `do...end` keywords) will be executed once for each of the two elements of the outer array, i.e., for `[1, 2]` and for `[3, 4]`. Within the block, on line 2, the `Array#first` method is called on the current inner array, returning the first element of that inner array. This return value is passed as an argument to the `puts` method, which converts it to a string, prints it to stdout (thus the output we see on line 4 and 5), and returns `nil`. So the return value of the last evaluated expression of the block is `nil`, hence the return value of the block is also `nil`, for each inner subarray. The `map` method uses this return value to transform the input array. Thus, `map` returns the array  `[nil, nil]` (which is what we see on line 6). *(950 chars)*

## Example 3

	[[1, 2], [3, 4]].map do |arr|
	  puts arr.first
	  arr.first
	end

On line 1, the `map` method is invoked on the two-dimensional array `[[1, 2], [3, 4]]`, passing a block (that spans from line 1 to line 4, demarcated by `do...end`). On each iteration, the current element of our two-dimensional array is assigned to the block argument `arr`. On line 2, `#Array#first` is invoked on the current inner array, returning its first element. Passing that return value, the `puts` method is invoked. `puts` converts its argument to a string, prints the string to stdout, and returns `nil`. On line 3, `Array#first` is called again on `arr`, again returning the first element of the current inner array. Since this is the last expression evaluated in the block, the block's return value is the first element of the inner array. This return value is used by `map` for transformation, so in the end, the invocation of the `map` method returns the array `[1, 3]`, consisting of the respective first elements of `[1, 2]` and `[3, 4]`.

## Example 4

	my_arr = [[18, 7], [3, 12]].each do |arr|
	  arr.each do |num|
	    if num > 5
	      puts num
	    end
	  end
	end

The code shows an `Array#each` method invocation nested in another `Array#each` method invocation, with the return value of the outer call to `each` assigned to the local variable `my_arr`.

First, `each` is invoked on the two-dimensional array `[[18, 7], [3, 12]]`, passing the block that spans from line 1 to line 7. Within the `each` invocation, the current element of the array (itself an array) is assigned to the block argument `arr`. Then, `each` is invoked again on `arr`, with the current element of `arr` is assigned to the inner block argument `num` (line 2). On line 3-5, a conditional is executed. The single branch of the conditional (on line 4) will be executed if `num > 5` is a truthy value (as per line 3). In our example, this will be the case iff `num > 5` evaluates to `true` (i.e., for the numbers `18`, `7`, `12`, which will be bound to `num` in turn, due to the two nested `each` invocations).

Now what happens based on the truthiness of `num > 5`?

- If `num > 5`, evaluates to `false`, no code inside of the conditional is  executed, and the conditional expression returns `nil`.
- If `num > 5` does evaluate to `true`, the `puts` method is invoked passing `num` as an argument. `puts` converts `num` to a string, prints it to stdout, and returns `nil`. Since this is the last line in the conditional that is evaluated, `nil` is also the return value of the conditional expression on line 3 to 5.

So in our example, the return value of the conditional expression is always `nil`. Since this is the last expression evaluated inside the inner block, the inner block will also return `nil`. However, the inner call to `each` does not make use of the return value: `each` returns the calling object. So the `each` invocation on line 2 will return the current inner array of our initial (outer) array. This is also the return value of the outer block.

However, again `each` does not use the return value of the block, so the outer invocation of `each` returns the original array, `[[18, 7], [3, 12]]`. Hence the local variable `my_arr` will point to that array as a result of the assignment on line 1.

Quick summary: the code will print `18`, `7` and `12`, and the value of `my_arr` will be `[[18, 7], [3, 12]]`.

## Example 5

	[[1, 2], [3, 4]].map do |arr|
	  arr.map do |num|
	    num * 2
	  end
	end

On line 1, the `Enumerable#map` method is invoked on the two-dimensional array `[[1, 2], [3, 4]]`. Along with the method invocation, the block spanning from line 1 to line 5 (demarcated by the `do ... end` pair of keywords) is passed to `map`. Since `map` is an iterator method, the block will be executed as many times as there are elements in the calling array – twice, in our case. On each iteration, the current inner array is bound to the block parameter `arr` (line 1).

Within the block, `map` is invoked again, this time on the array bound to `arr`. Along with the inner `map` incovation, the inner block spanning from line 2 to line 4 is passed to `map`. On each inner iteration, the current element of the inner array is bound to the block parameter `num` (line 2).

Within the inner block, `num` is doubled (line 3), more precisely, the `*` method is called on `num`, passing the argument `2`, and thus returning twice the value of `num`. Since `num * 2` is the last expression evaluated in the inner block, this is also the return value of the inner block. `map` uses the return value to transform the elements of the inner array, hence the inner call to map will return a new two-element array, with the elements from the original inner array doubled. This is also the return value of the outer block, which is used by the outer call to `map` for transformation. So the return value of the outer call to `map` will consist of the two-dimensional array `[[2, 4], [6, 8]]`, which in turn consists of the two two-element arrays that were returned by the inner `map` method invocation.

## Example 6

	[{ a: 'ant', b: 'elephant' }, { c: 'cat' }].select do |hash|
	  hash.all? do |key, value|
	    value[0] == key.to_s
	  end
	end
	# => [{ :c => "cat" }]


On line 1, the `Enumerable#select` method is invoked on the array `[{ a: 'ant', b: 'elephant' }, { c: 'cat' }]`, which contains two hashes as its elements. Along with the method invocation, the block spanning from line 1 to 5 (demarcated by `do ... end` keywords) is passed to `select`. On each iteration the block, the block parameter `hash` is bound to the current element of the calling array. On line 3, the `all?` method is invoked on `hash`, and a block is passed to `all?` alongside the method invocation (call this block the "inner block"). On each iteration of `all?`, the current key-value pair of the hash `hash` is bound to the two block parameters `key` and `value`. Then, the line `value[0] == key.to_s` is evaluated: on the left side, the `String#[]` method is called on the value component of the key-value pair (which *is* a string!), passing the argument `0` and returning a single-char string: the character at the very beginning of the string. On the right side, the `to_s` method is called on the key component of the key-value pair. `==` checks whether the objects returned by the left side and by the right side have the same value, and returns `true` or `false` depending on the answer to this question. Since this is the last expression evaluated in the inner block, the inner block returns a boolean. If that return value is `true` for each iteration of the inner block (i.e., for each key-value pair of `hash`), the `all?` invocation returns `true`, otherwise, the invocation returns `false`. This latter return value is also the return value of the outer block, i.e., a boolean, which is used by `select` to select elements from the caller. The return value of `select` is a new array containing those elements that have been selected. Tying all our observations together, we see that `Enumerable#select` will select those hashes for which the first character of each key-value pair's value is equal to the string representation of the key (which is a symbol). Since this is the case only for the second hash, the `select` invocation returns `[{ c: 'cat'}]`.


*Instructor description (not meant to be exhaustive):*

The first thing to notice here is the use of the all? method within the select block. Since #select specifically cares about the truthiness of the block's return value, using a method that returns a boolean works well. all? will return true if the block passed to it never returns a value of false or nil for every key/value pair in the hash. We're using value[0] == key.to_s to test whether all keys match the first letter of all their associated values. Note that the only hash that meets this criteria is {:c => 'cat'}, and the return value is an array.

## Example 8

> It can be tricky to work with different objects in a nested array if you want to only select nested elements based on certain criteria. For example, take the 2-element array below, where we only want to select integers greater than 13 but strings less than 6 characters. The trick here is that the elements are in a two layer nested array data structure.

	[[8, 13, 27], ['apple', 'banana', 'cantaloupe']].map do |arr|
	  arr.select do |item|
	    if item.to_s.to_i == item    # if it's an integer
	      item > 13
	    else
	      item.size < 6
	    end
	  end
	end
	# => [[27], ["apple"]]


In this example, we are dealing with an inner block passed to a `select` invocation nested inside an outer block passed to a `map` invocation.

On line 1, the `Enumerable#map` method is invoked on the two-dimensional array `[[8, 13, 27], ['apple', 'banana', 'cantaloupe']]`. Along with the method invocation, a block is passed to `map` (the block spans from line 1 to line 9). Since `map` is an iterator, the block will run twice, once for each element of the array on which `map` was called.

The block parameter `arr` is bound to each of these two array elements in turn. Now inside of the block, another iterator method is invoked on `arr`: the `Enumerable#select` method. An inner block is passed to `select` as part of the method invocation (this block spans line 2 to 8). Since `select` is again an iterator method, the block will run once for each element of the inner array that is bound to `arr`. The inner block again has a block parameter, `item`, which is bound to the current element of `arr` on each iteration. Within the inner block, we find a conditional spanning line 3 to line 7 (the code from `if` to `end` on line 7).

The return value of this conditional will determine whether an element of the current inner array is selected by `select` (i.e., ends up as an element in the array returned by `select`).

Let's now look at the conditional in detail. Which branch of the conditional gets executed (the one on line 4, or the one on line 6) depends on whether the expression `item.to_s.to_i == item` is truthy (for the current element of the current inner array). This expression is truthy if `item` evaluates to an integer (at least approximately, the expression is not a perfect test for integer-hood). This is the case for all elements of the first inner array, and not the case for all elements of the second inner array.

So for the first inner array, the first branch of the conditional will get executed for each of the elements of the inner array, returning the object `item > 13` evaluates to (which is going to be `true` or `false`).

This object will also be the return value of the inner block, and its truthiness will be used by `select` to select the elements of the inner array of numbers. This means that on the first iteration of the `map` block, the invocation of `select` will return the array `[27]`, as `27` is the only number in the first inner array that is greater than 13.

Turning to the second inner array, since `item.to_s.to_i == item` will evaluate to `false` for each of its elements, the second branch of the conditional will get executed for each of them. So the conditional will return the object `item.size < 6` evaluates to, which will again be either `true` or `false`. Again, the return value of the conditional is also the return value of the inner block, whose truthiness will be used by `select` to select elements of the (second, in this case) inner array. This means that on the second iteration of the `map` block, the invocation of `select` will return the array containing the single string `apple`, as `apple` is the only string in the second inner array that has less six characters.

Tying this together, we see that the block passed to `map` will return `[27]` on the first iteration, and `['apple']` on the second iteration. Given the way `map` works (it uses the return value of the block for transformation), the return value of the `map` invocation is the nested array `[[27], ['apple']]`.
