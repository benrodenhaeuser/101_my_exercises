
**Exercise:**
Examine the code example below. The last line outputs the String 'Hi' rather than the String 'Hello'. Explain what is happening here and identify the underlying principle that this demonstrates.

```ruby
greeting = 'Hello'

loop do
  greeting = 'Hi'
  break
end

puts greeting
```

**Answer**

- On line 1 of the program, the local variable `greeting` is initialized to a String object with value `'Hello'`.
- On line 3, the `loop` method is invoked, passing a block as part of the method invocation. The block extends from line 3 to line 6 and is delineated by the pair of keywords `do ... end`.
- Within the block, `greeting` is re-assigned (on line 4) to a new String object with value `'Hi'`.
- This is possible because the scope created by the block extends the main scope of the program. All local variables that are initialized in the main scope, and prior to the block, are accessible from the block scope, in particular the local variable `greeting` that was initialized on line 1.
- On line 8, we are back in the main scope. Since the local variable `greeting` was accessible from the block scope, and was re-assigned in the block (as described above), the local variable `greeting` at this point points to a String object with value `Hi`.
- Thus, on line 8, as the `puts` method is called, passing the argument `greeting`, `'Hi'` is output.
- What the code example demonstrates is the fact that variables that have been initialized in an outer scope are accessible from an inner scope that is created by a block passed as part of a method invocation. This is an important scoping rule for local variables in Ruby.

**Instructor Answer**

[Source](https://launchschool.com/lessons/3ce27abc/assignments/cd8e4629)

The local variable `greeting` is assigned to the String 'Hello' on line 1. The `do..end` alongside the `loop` method invocation on lines 3 to 6 defines a block, within which `greeting` is reassigned to the String `Hi` on line 4. The `puts` method is called on line 8 with the variable `greeting` passed to it as an argument; since `greeting` is now assigned to 'Hi', this is what is output. This example demonstrates local variable scoping rules in Ruby; specifically the fact that a local variable initialized outside of a block is accessible inside the block.
