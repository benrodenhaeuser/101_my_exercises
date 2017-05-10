*Goal:* Get clearer about the relationship between `sort_by` on the one hand, and `sort` and `<=>` on the other.

*Hunch:* Conceptually, `sort_by` is fairly closely related to the `map` method.

*Example:* sort the following array by the numerical values of its elements:

```ruby
arr = ['0', '10', '3']
```

This can be achieved using `sort_by`:

```ruby
arr.sort_by do |string|
  string.to_i
end
# => ['0', '3', '10']s
```

Or more briefly:

```ruby
arr.sort_by(&:to_i)
# => ['0', '3', '10']
```

Now the question is how does `sort_by` do its magic? There is a hint in the Ruby Docs: ["The current implementation of `sort_by` generates an array of tuples containing the original collection element and the mapped value"](http://ruby-doc.org/core-2.4.1/Enumerable.html#method-i-sort_by).

Based on this, I think what `sort_by` must be doing is something like this:

1. Map the given array to an array of pairs (using the argument `sort_by` was given – a method symbol, or a block).
2. Sort the array of pairs by the second component of each pair (relying on `<=>`).
3. Project each pair onto its first component.

The result of step 3 is your sorted array. I have no way to check whether this is really "what is going on" internally. But one way to demonstrate that this is a viable mental model is to reimplement `sort_by` based on the this model.

First, we observe that we can actually mimick the above three steps in Ruby code fairly closely. This is where the `map` method comes into play. For our running example, observe that the sorted array can be obtained as follows:

```ruby
arr.map { |elem| [elem, elem.to_i] } # step (1)
  .sort { |pair1, pair2| pair1.last <=> pair2.last } # step (2)
  .map { |pair| pair.first } # step (3)
# => ['0', '3', '10']
```

Note that we have replaced the invocation of `sort_by` with calls to `map`, `sort` and `<=>`.

Generalizing this idea, here is an implementation of a method `my_sort_by` that takes a collection as an argument, and a block:

```ruby
def my_sort_by(collection)
  collection.map { |elem| [elem, yield(elem)] }
    .sort { |pair1, pair2| pair1.last <=> pair2.last }
    .map { |pair| pair.first }
end
```

Invoked with our running example:

```ruby
my_sort_by(arr) { |elem| elem.to_i } # => ['0', '3', '10']
```

Or, using the shorthand notation from above:

```ruby
my_sort_by(arr, &:to_i) # => ['0', '3', '10']
```

We can also implement `my_sort_by` as an `Enumerable` method:

```ruby
module Enumerable
  def my_sort_by
    self.map { |elem| [elem, yield(elem)] }
      .sort { |pair1, pair2| pair1.last <=> pair2.last }
      .map { |pair| pair.first }
  end
end
```

Now we can call `my_sort_by` *on* a collection like this:

```ruby
arr.my_sort_by { |elem| elem.to_i } # => ['0', '3', '10']
```

Or like this:

```ruby
arr.my_sort_by(&:to_i) # => ['0', '3', '10']
```
