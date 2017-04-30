# Problem 5

# Write a program that outputs all possibilities to put + or - or nothing
# between the numbers 1, 2, ..., 9 (in this order) such that the result is
# always 100. For example: 1 + 2 + 34 – 5 + 67 – 8 + 9 = 100.

# -------

TARGET_VALUE = 100

# helper method to display an array of summands
# of the required form as a sum expression
def display_expression(seq)
  seq.inject('') do |string, summand|
    if summand.to_s.start_with?('1')
      summand.to_s
    elsif summand > 0
      string + ' + ' + summand.to_s
    else
      string + ' - ' + summand.abs.to_s
    end
  end
end

# SOLUTION 1: Recursion

def solve(seq, stock, solutions)
  if stock == []
    solutions << seq if seq.reduce(&:+) == TARGET_VALUE
  else
    solve(seq + [stock.first], stock.drop(1), solutions)
    solve(seq + [-stock.first], stock.drop(1), solutions)
    solve(
      seq[0..-2] + [(seq.last <=> 0) * (10 * seq.last.abs + stock.first)],
      stock.drop(1),
      solutions
    )
  end
end

solutions = []
solve([1], (2..9).to_a, solutions)
solutions.each { |solution| puts display_expression(solution) }

# [1, 2, 3, -4, 5, 6, 78, 9]
# [1, 2, 34, -5, 67, -8, 9]
# [1, 23, -4, 5, 6, 78, -9]
# [1, 23, -4, 56, 7, 8, 9]
# [12, 3, 4, 5, -6, -7, 89]
# [12, 3, -4, 5, 67, 8, 9]
# [12, -3, -4, 5, -6, 7, 89]
# [123, 4, -5, 67, -89]
# [123, 45, -67, 8, -9]
# [123, -4, -5, -6, -7, 8, -9]
# [123, -45, -67, 89]

puts '------------------------'

# SOLUTION 2: Iteration

def generate_sequences
  (2..9).inject([[1]]) do |sequences, number|
    sequences.flat_map do |seq|
      [
        seq + [number],
        seq + [-number],
        seq[0..-2] + [(seq.last <=> 0) * (10 * seq.last.abs + number)]
      ]
    end
  end
end

def select_sequences
  generate_sequences.select do |seq|
    seq.reduce(&:+) == TARGET_VALUE
  end
end

select_sequences.each { |seq| puts display_expression(seq) }

# 1 + 2 + 3 - 4 + 5 + 6 + 78 + 9
# 1 + 2 + 34 - 5 + 67 - 8 + 9
# 1 + 23 - 4 + 5 + 6 + 78 - 9
# 1 + 23 - 4 + 56 + 7 + 8 + 9
# 12 + 3 + 4 + 5 - 6 - 7 + 89
# 12 + 3 - 4 + 5 + 67 + 8 + 9
# 12 - 3 - 4 + 5 - 6 + 7 + 89
# 123 + 4 - 5 + 67 - 89
# 123 + 45 - 67 + 8 - 9
# 123 - 4 - 5 - 6 - 7 + 8 - 9
# 123 - 45 - 67 + 89