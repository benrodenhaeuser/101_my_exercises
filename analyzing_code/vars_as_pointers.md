# Problem 1:

```ruby
a = 2
b = [5, 8]
arr = [a, b]

arr[0] += 2
arr[1][0] -= a
```

## Values of `a` and `b`

```ruby
a == 2
b == [3, 8]
```

## Explanation

After line 3:
- the local variable `a` points to the integer 2.
- the local variable `b` points to an Array object, which contains two elements. Each element is a reference to an integer, 5 and 8.
- the local variable `arr` points to another array object, which contains two elements. The first element is a reference to the integer 2, the second element is a reference to an array: the same array object to which `b` also points.

After line 4:
- the first element of `arr` now points to the integer 4 (2 incremented by 2). This does not affect the reference of `a`. The reference of `a` used to be also referenced by the first element of `arr` – but no longer! Still, the reference of `a` remains the same: `a` points to the integer 2.

After line 5:
- the array to which `arr` points has been changed. Namely, the first element of that array now points to 3 (5 decremented by the value of a). This affects the value of `b`, because the array to which `arr` points is the very same array to which `b` points! So `b` now points to the array `[3, 8]` (i.e., the same array as before, but with the first element changed).

Summing up: `a` (still) points to the integer object 2, and `b` now points to the array object `[3, 8]`. This explains the final values we get.

This demonstrates the importance of thinking of variables as pointers to objects in memory.

It also demonstrates an important difference between numbers and arrays in Ruby: while number objects completely encapsulate their value, array objects contain references to further objects, one such reference for each element of the array. (???)

# Problem 2

```ruby
a = 'hello'
arr = [a]

arr[0] = arr[0] * 2
```

## Values of `a` and `arr`?

```
a == 'hello'
arr == ['hellohello']
```

## Explanation

After line 2:

- The variable `a` references the string object 'hello'. The variable `arr` references a one-element array. The single element of `arr` references the same string object as the variable `a`.

After line 4:

- The reference of the single element of `arr` has been changed to a new string object `hellohello`. This is not the same string as our original `hello` string. So the value of `a` is not affected.

# Problem 3

```ruby
a = 'hello'
arr = [a]

arr[0] = arr[0] << 'hello'
```

## Values of `a` and `arr`

```ruby
a == 'hellohello'
arr == ['hellohello']
```

## Explanation

After line 2:

- The situation after line 2 is exactly like in the previous example.

After line 4:

- The reference of the single element of `arr` remains to the same string. However, the string has been mutated by the call to `<<`. Since `a` also points to this string, `a` now evaluates to `hellohello`.
