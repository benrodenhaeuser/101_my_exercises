# Problem 5

# Write a program that outputs all possibilities to put + or - or nothing between
# the numbers 1, 2, ..., 9 (in this order) such that the result is always 100.
# For example: 1 + 2 + 34 – 5 + 67 – 8 + 9 = 100.

# SOLUTION 1: Recursive

def solve(summands, stock, solutions)
  if stock == []
    solutions << summands if summands.reduce(&:+) == 100
  else
    solve(summands + [stock.first], stock.drop(1), solutions)
    solve(summands + [-stock.first], stock.drop(1), solutions)
    solve(
      summands[0..-2] + [(summands.last.to_s + stock.first.to_s).to_i],
      stock[1..-1],
      solutions
    )
  end
end

def display_string(summands)
  summands.inject('') do |string, summand|
    if summand.to_s.start_with?('1')
      summand.to_s
    elsif summand > 0
      string + ' + ' + summand.to_s
    else
      string + ' - ' + summand.abs.to_s
    end
  end
end

def show_the_solutions
  solutions = []
  solve([1], (2..9).to_a, solutions)
  solutions.each { |solution| puts display_string(solution) }
end

puts "Results for recursive approach:"

show_the_solutions

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


# SOLUTION 2: Iterative

def generate_sequences
  (2..9).inject([[1]]) do |sequences, number|
    sequences.flat_map do |sequence|
      [
        sequence + [' + ', number],
        sequence + [' - ', number],
        sequence[0..-2] + [(sequence.last.to_s + number.to_s).to_i]
      ]
    end
  end
end

def evaluate_sequence(sequence)
  result = sequence.first
  sequence.each_with_index do |value, index|
    if index.odd?
      case value
      when ' + ' then result += sequence[index + 1]
      when ' - ' then result -= sequence[index + 1]
      end
    end
  end
  result
end

def select_sequences
  generate_sequences.select do |sequence|
    evaluate_sequence(sequence) == 100
  end
end

def show_solutions
  select_sequences.each { |sequence| puts sequence.join }
end

puts "Results for iterative approach:"

show_solutions

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
