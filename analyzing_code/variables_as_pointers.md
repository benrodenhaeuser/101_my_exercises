# Problem 1

```ruby
a = 2
b = [5, 8]
arr = [a, b]

arr[0] += 2
arr[1][0] -= a
```

## Values of `a`, `b` and `arr`

```ruby
a == 2
b == [3, 8]
arr == [4, [3, 8]]
```

## Explanation

### After line 3

- The local variable `a` points to the integer 2.
- The local variable `b` points to an Array object with two objects. Each element is a reference to an integer (`5` and `8`).
- The local variable `arr` points to *another* array object, which contains two elements. The first element is a reference to the integer `2`, the second element is a reference to an array: the same array object to which `b` also points.
- In terms of a count, we now have three integer objects (`2`, `5`, `8`), two array objects (`[5, 8]` and `[2, [5, 8]]`), and three variables, `a`, `b` and `arr`.

Summarizing:

- `a` points to `2`.
- `b` points to `[5, 8]`.
- `arr` points to `[2, [5, 8]]`.

### After line 4

- The first element of `arr` has been reassigned, and now points to the integer `4` (`2` incremented by `2`).
- This change of reference for the array element does not affect the variable `a`, so `a` still points to `2`.
- On top of the objects we used to have after line 3, we now have a new integer object, `4`, referenced by `arr[0]`.

Summary of where variables point to:

- `arr` points to `[4, [5, 8]]`.
- `a` has not been affected, still points to `2`.
- `b` has not been affected, still points to `[5, 8]`.

### After line 5

- The array to which `arr[1]` points has been changed. Namely, the first element of that array now points to `3` (`5` decremented by the value of `a`, which is `2`). Notice that `b` (still) points to that very same array, which has by now been changed to `[3, 8]`.
- A new Integer object has come into existence, `3`. On the other hand, the Integer object `5` is now "gone" for all intents and purposes, as it is not referenced by any variable or array element anymore.

In terms of variables as pointers:

- `b` now points to `[3, 8]`.
- `arr` points to `[4, [3, 8]]`.
- `a` has not been affected, it still points to `2`.

Hence what was said above:

```ruby
a == 2
b == [3, 8]
arr == [4, [3, 8]]
```

# Problem 2

```ruby
a = 'hello'
arr = [a]

arr[0] = arr[0] + ' world'
```

## Values of `a` and `arr`?

```ruby
a == 'hello'
arr == ['hello world']
```

## Explanation

After line 2:

- The variable `a` references the string object 'hello'. The variable `arr` references a one-element array. The single element of `arr` references the same string object as the variable `a`.

After line 4:

- The single element of `arr` now points to a new string object `hello world`. The new string object was obtained by calling the `+` method on the string `hello`, passing the argument `' world'`. This call did not affect the original string object to which `a` points. So the value of `a` is not affected.

- So we now have two variables, and three objects: the variables are `a` and `arr`, the objects are the reference of `a` (the string `'hello'`), the array object, and the string `hello world` referenced by the single array element.

# Problem 3

```ruby
a = 'hello'
arr = [a]

arr[0] = arr[0] << ' world'
```

## Values of `a` and `arr`

```ruby
a == 'hello world'
arr == ['hello world']
```

## Explanation

After line 2:

- The situation after line 2 is exactly like in the previous example.

After line 4:

- The reference of the single element of `arr` remains to the same string. However, the string has been mutated by the call to `<<`. Since `a` also points to this string, `a` now evaluates to `hello world`.

- So compared to the previous example, we have *fewer objects* after line 4 than we had in that previous example after line 4: we have two variables, `a` and `arr`, as before, but there are only two objects, rather than three: the two objects are one array and one string.
