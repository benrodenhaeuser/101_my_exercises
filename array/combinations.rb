# given a set s of n > k elements, enumerate all k-combinations of the set, i.e., all subsets of arr that contain k elements.

=begin

understanding:

example:
{ a, b, c, d }

ab, ac, ad, bc, bd, cd

first idea:
- choose an element from the set
- choose an element from the remaining set
- repeat until you have chosen k elements

problem: this will give us a lot of repetitions.

e.g., we would do a computation
"choose a, then b"
and later another one
"choose b, then a"

how to avoid this?

second idea:
carry forward what elements are already taken care of.

pseudo code:

def combinations(set, number)
  if number == 1
    return the set of singleton sets obtained from set
  elsif |set| >= number
      first_batch = x + each of the combos in combinations(set - x, number - 1)
      second_batch = combinations(set - x, number)
      return both batches
    end
  else
    []
  end
end

=end

# ---------------------------------------------------------------------------
# solution 1
# ---------------------------------------------------------------------------

# assume that k > 0

def combine(array, k)
  return puts "combinations need to have a positive length" if k <= 0

  if k == 1
    array.map { |elem| [elem] }
  elsif array.size >= k
    combine(array[1..-1], k - 1).map { |rest| [array[0]] + rest } +
    combine(array[1..-1], k)
  else
    []
  end
end

p combine([1, 2], 3)
# => []

p combine([], 1)
# => []

p combine([1, 2], 0)
# => combinations need to have a positive length

p combine([1, 2, 3, 4], 2)
# => [[1, 2], [1, 3], [1, 4], [2, 3], [2, 4], [3, 4]]

p combine([1, 2, 3, 4], 3)
# => [[1, 2, 3], [1, 2, 4], [1, 3, 4], [2, 3, 4]]

p combine([1, 2, 3, 4, 5], 5)
# => [[1, 2, 3, 4, 5]]
