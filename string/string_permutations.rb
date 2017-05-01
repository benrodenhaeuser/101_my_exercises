# given a string, find all permutations of the string

# solution 1

def all_permutations(string)
  produce_all_permutations(string).sort
end

def produce_all_permutations(string)
  if string.size <= 1
    [string]
  else
    permus = []
    first = string[0]
    rest = string[1...string.size]
    all_permutations(rest).each do |permu|
      (0..permu.size).each do |position|
        permus << permu[0...position] + first + permu[position...permu.size]
      end
    end
    permus
  end
end

p all_permutations('')
puts
p all_permutations('a')
puts
p all_permutations('ab')
puts
p all_permutations('abc')
puts
p all_permutations('abcd')
puts
p all_permutations('abcde')

3.times { puts }

# solution 2

def generate_permutations(stock, chosen, permus)
  if stock.empty?
    permus << chosen
  else
    stock.each_with_index do |choice, index|
      new_stock =
        stock[0...index] + stock[index + 1...stock.size]
      generate_permutations(new_stock, chosen + choice, permus)
    end
  end
  nil
end

def permutations(string)
  permus = []
  generate_permutations(string.chars, '', permus)
  permus
end

p permutations('')
puts
p permutations('a')
puts
p permutations('ab')
puts
p permutations('abc')
puts
p permutations('abcd')
puts
p permutations('abcde')
puts
