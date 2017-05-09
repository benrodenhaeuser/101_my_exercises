Sort the following array by the numerical values of its elements:

```ruby
['0', '10', '3']
```

Using `Enumerable#sort_by`, this can be achieved as follows:

```ruby
['0', '10', '3'].sort_by do |string|
  string.to_i
end
# => ['0', '3', '10']
```

What is a mental model to think of what `sort_by` is doing here?

- Associate each element of the input array with a *sort key*, i.e., an object of the right kind for the particular way we want to sort (?). In this case, we need to associate each string with a number representation of that string. This results in a list of pairs of values, which we can represent by a nested array (this is probably not quite how Ruby represents this, but it should be something structurally similar):

```ruby
[['0', 0], ['10', 10], ['3', 3]]
```

- Sort the list of pairs of values by the second value, relying on the `<=>` method that comes with the second value. In our example, this results in

```ruby
[['0', 0], ['3', 3], ['10', 10]]
```

- Project the list of pairs of values to list containing the first value in each pair:

```ruby
['0', '3', '10']
```

- That's your sorted array.

- Now what `sort_by` allows us to do is instead of doing all of this by ourselves: Simply specify (in the block that is passed to `sort_by`) the second component of each pair in the above list of pairs of values – and `sort_by` will take care of the rest.
