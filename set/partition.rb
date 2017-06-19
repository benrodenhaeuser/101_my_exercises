# generate all partitions of a set { 0, ..., n - 1 }.

=begin

example:
for n = 4, there are 15 partitions, namely:

{0123}
{012,3}
{013,2}
{01,23}
{01,2,3}
{023,1}
{02,13}
{02,1,3}
{03,12}
{0,123}
{0,12,3}
{03,1,2}
{0,13,2}
{0,1,23}
{0,1,2,3}

what could be a way to generate those systematically?
does this problem have a recursive structure?

what is a smallest instance of this problem?
- well, the empty set has just one partition: {} (note that this does not include empty sets as elements of the partition!)
- what about a singleton set {a}? there is again only one partition: { {a} }
- so we have potential base cases for a recursion.

what about the recursive step? given a set, can we reformulate the problem in terms of a smaller problem instance?

"choose one element, take the union with a partition of the rest"
==> this alone would lead us to {1,2,3,4} in our above example (I think). We keep chewing off single elements.

how about something like this?

- for any number k from 1 up to n:
  - choose any k-combination (subset) of the set, and take the union with a partition of the complement of that k-combination.
  - does this capture all partitions without partitions? no, it doesn't.







=end
