# Problem 5

# Write a program that outputs all possibilities to put + or - or nothing
# between the numbers 1, 2, ..., 9 (in this order) such that the result is
# always 100. For example: 1 + 2 + 34 – 5 + 67 – 8 + 9 = 100.

# -------

TARGET_VALUE = 100

# helper method to format an array of summands
# of the required form as a sum expression
def get_display_expression(sequence)
  sequence.inject('') do |string, summand|
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
  nil
end

solutions = []
solve([1], (2..9).to_a, solutions)
solutions.each { |solution| puts get_display_expression(solution) }

puts "-----"

# SOLUTION 2: Iteration

def generate_all_sequences
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

def select_target_sequences
  generate_all_sequences.select { |seq| seq.reduce(&:+) == TARGET_VALUE }
end

select_target_sequences.each { |seq| puts get_display_expression(seq) }
