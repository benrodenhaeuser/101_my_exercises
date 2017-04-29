# Problem 5

# Write a program that outputs all possibilities to put + or - or nothing between
# the numbers 1, 2, ..., 9 (in this order) such that the result is always 100.
# For example: 1 + 2 + 34 – 5 + 67 – 8 + 9 = 100.

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

select_sequences.each { |sequence| puts sequence.join }

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
