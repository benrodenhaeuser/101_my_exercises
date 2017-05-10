*Goal:* Get clearer about the relationship between `sort_by` on the one hand, and `sort`, `map` and `<=>` on the other.

*Hunch:* `sort_by` is fairly closely related to the `map` method, not in terms of implementation, but in conceptual terms.

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

One way to think of what `sort_by` is doing here is like this:

1. Map the given array to an array of pairs (using the argument `sort_by` was given – a method symbol, or a block).
2. Sort the array of pairs by the second component of each pair (relying on `<=>`).
3. Project each pair onto its first component.

`sort_by` makes life very easy for us because all we have to is describe what the "mapping" in step 1 should look like. To achieve this, we can either pass a block or a method symbol to `sort_by`, as seen above.

We can actually mimick these three steps in Ruby code fairly closely using the `map` method. For our running example, this looks like this:

```ruby
arr.map { |elem| [elem, elem.to_i] } # step (1)
  .sort { |pair1, pair2| pair1.last <=> pair2.last } # step (2)
  .map { |pair| pair.first } # step (3)
# => ['0', '3', '10']
```

This makes it conceptually clearer how `sort_by` is connected with `sort` and `<=>`.

Based on the above observations, we can implement our own sort_by functionality:

```ruby
def my_sort_by(collection, method_symbol)
  collection.map { |elem| [elem, elem.send(method_symbol)] }
    .sort { |pair1, pair2| pair1.last <=> pair2.last }
    .map { |pair| pair.first }
end
```

This method may be called with a collection and method symbol. Using our running example:

```ruby
my_sort_by(arr, :to_i) # => ['0', '3', '10']
```

How about a `my_sort_by` method that would work based on a block? This could look like this:

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

So now we have implemented our own sort_by using `sort` and `<=>`.
