# Goal: Get clearer about the relationship between `sort_by` on the one hand, and `sort` and `<=>` on the other.

# Problem: sort the following array by the numerical values of its elements:

arr = ['0', '10', '3']

# This can be achieved using sort_by:

arr.sort_by do |string|
  string.to_i
end
# => ['0', '3', '10']

# Or more briefly:

arr.sort_by(&:to_i)
# => ['0', '3', '10']

# One way to think of what sort_by is doing is like this:
# It (1) maps the array to an array of pairs,
# (2) sorts that array by the second component of each pair (relying on `<=>`),
# and (3) then projects each pair onto its first component.

# sort_by makes life very easy for us because all we have to is specify what
# the "mapping" in step 1 should look like. To achieve this, we can either pass
# a block or a method symbol to sort_by, as seen above.

# We can actually mimick these three steps in Ruby code as follows. For our
# running example, this looks like this:

arr.map { |elem| [elem, elem.to_i] } # step (1)
  .sort { |pair1, pair2| pair1.last <=> pair2.last } # step (2)
  .map { |pair| pair.first } # step (3)

# => ['0', '3', '10']

# This makes it conceptually clearer (for me) how sort_by is connected with
# `sort` and `<=>`.

# Based on these observations, we can implement our own sort_by functionality:

def my_sort_by(collection, method_symbol)
  collection.map { |elem| [elem, elem.send(method_symbol)] }
    .sort { |pair1, pair2| pair1.last <=> pair2.last }
    .map { |pair| pair.first }
end

my_sort_by(arr, :to_i) # => ['0', '3', '10']

# This mimicks invoking sort_by with a method symbol. How about a block? This could look like this:

def my_sort_by(collection)
  collection.map { |elem| [elem, yield(elem)] }
    .sort { |pair1, pair2| pair1.last <=> pair2.last }
    .map { |pair| pair.first }
end

my_sort_by(arr) { |elem| elem.to_i } # => ['0', '3', '10']

# So now we have implemented our own sort_by using sort and <=>.
