require 'benchmark'

# given a string, find all permutations of the string

=begin

I. understanding the problem.

- a string permutation is a way to reorder the letters in the string
  - e.g. 'neb' is a permutation of 'ben'
  - and 'nonb' is a permutation of 'bonn'
- how many permutations do we get given an input string?
  - has to do with length of string, e.g.
    - 'a' has one permutation ('a')
    - 'ab' has two permutations ('ab', 'ba')
  - also depends on whether there are repetitions in input string
    - 'ab' has two permutations
    - 'bb' has only one

- one idea to take care of repetitions is to remove them at the end of the algorithm. another idea is to avoid building them in the first place.

II. data structure

- internally, we will represent the string as an array of chars (our stock)

III. solution

- initialize array of permutations (initially empty)
- for each character from our stock:
  - that character concatenated with all permutations of the remaining stock goes into our array of permutations

=end

# solution 1

def permutations(string)
  if string.size == 1
    perms = [string]
  else
    perms = []
    string.chars.each_index do |index|
      permutations(string[0...index] + string[index + 1..-1]).each do |perm|
        perms << string[index] + perm
      end
    end
  end
  perms.uniq
end

puts Benchmark.realtime { permutations('abcd') } # 0.0001009996049106121
puts Benchmark.realtime { permutations('abcdef') } #
puts Benchmark.realtime { permutations('aaaaaaaaa') } # 0.9907749998383224

# => the call to uniq at the end is heavy-handed. much better to not generate those permutations in the first place.

# solution 2

def permutations(string)
  permus = []
  stock = build_stock(string)
  generate_permutations(stock, '', permus)
  permus
end

def build_stock(string)
  stock = Hash.new { |hash, key| hash[key] = 0 }
  string.chars.each do |char|
    stock[char] += 1
  end
  stock
end

def generate_permutations(stock, chosen, permus)
  if stock.keys.none? { |key| stock[key] > 0 }
    permus << chosen
  else
    stock.keys.each do |choice|
      if stock[choice] > 0
        stock[choice] -= 1
        generate_permutations(stock, chosen + choice, permus)
        stock[choice] += 1
      end
    end
  end
  nil
end


puts Benchmark.realtime { permutations('abcd') } # 0.00016999989748001099
puts Benchmark.realtime { permutations('abcdef') } #
puts Benchmark.realtime { permutations('aaaaaaaaa') } # 2.2999942302703857e-05

# the second solution is *a lot* more efficient for repetitive strings (see above) — which was kind of the point
