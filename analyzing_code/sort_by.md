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
# => ['0', '3', '10']
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

The result of step 3 is your sorted array. Now presumably the above is not *quite* what is happening internally, but I am going to assume it's reasonably close.

The `sort_by` method makes life very easy for us because all we have to do is describe what the "mapping" in step 1 should look like. How do we describe this? Either pass a block or a method symbol, as seen above. In the case of passing a block, the *return value of the block* is used to obtain the second component of that tuple the Ruby Docs talk about.

We can actually mimick the above three steps in Ruby code fairly closely. Doing this spells out the conceptual link to the `map` method more clearly. For our running example, observe that the sorted array can be obtained as follows:

```ruby
arr.map { |elem| [elem, elem.to_i] } # step (1)
  .sort { |pair1, pair2| pair1.last <=> pair2.last } # step (2)
  .map { |pair| pair.first } # step (3)
# => ['0', '3', '10']
```

This also makes it tangible how `sort_by` is related to `sort` and `<=>`.

Based on the above observations, we can actually implement our own `sort_by` functionality:

```ruby
def my_sort_by(collection, method_symbol)
  collection.map { |elem| [elem, elem.send(method_symbol)] }
    .sort { |pair1, pair2| pair1.last <=> pair2.last }
    .map { |pair| pair.first }
end
```

This method is called with a collection and a method symbol as arguments. Using our running example:

```ruby
my_sort_by(arr, :to_i) # => ['0', '3', '10']
```

How about a `my_sort_by` method that would work based on a block?

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
