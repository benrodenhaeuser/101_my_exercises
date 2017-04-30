
**Exercise:**
Examine the code example below. The last line outputs the String 'Hi' rather than the String 'Hello'. Explain what is happening here and identify the underlying principle that this demonstrates.

1    greeting = 'Hello'
2
3    loop do
4      greeting = 'Hi'
5      break
6    end
7
8    puts greeting

**Answer**

- On line 1 of the eight-line program, the local variable `greeting` is initialized to a String object with value `"Hello"`.
- On line 3, the `loop` method is invoked, passing a block that extends from line to line 6 (the block is delineated by the pair of keywords `do ... end`).
- Within the block, `greeting` is re-assigned (on line 4) to a different String object with value `"Hi"`.
- This is possible because the scope created by the block (that is passed to `loop` as part of the method invocation) extends the main scope of our program. So all local variables initialized in the main scrope preceding the block are accessible in the block scope.
- In line 5, we break out of the loop using the `break` keyword (if we were to delete line 5 from the program, the loop would continue forever, the program would not terminate).
- So in line 9, we are back in the main scope. Since the local variable `greeting` was accessible from the block, and was re-assigned as pointed out above, the local variable `greeting` now points to a String object with value `Hi`.
- Thus, on line 8, as the `puts` method is called passing the argument `greeting`, `'Hi'`, which is by now the value (of the object) `greeting` points to, is output.
- As an aside: the return value of both method invocations in this program is `nil`: the invocation of `loop` on line 3 returns `nil`, and so does the invocation of `puts` on line 8.
- What the code example illustrates is the fact that variables that have been initialized in an outer scope are accessible from the scope that is created by a block passed as part of a method invocation. This is an important scoping rule for local variables in Ruby.
