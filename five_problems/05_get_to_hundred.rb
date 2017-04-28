# Problem 5

# Write a program that outputs all possibilities to put + or - or nothing between the numbers 1, 2, ..., 9 (in this order) such that the result is always 100. For example: 1 + 2 + 34 – 5 + 67 – 8 + 9 = 100.

TARGET_SUM = 100

def generate_all_choice_sequences
  current_sequences = [[:plus], [:minus], [:next]]

  7.times do
    next_sequences = []
    current_sequences.each do |sequence|
      next_sequences << sequence + [:plus]
      next_sequences << sequence + [:minus]
      next_sequences << sequence + [:next]
      current_sequences = next_sequences
    end
  end

  current_sequences
end

def generate_list_of_summands(choice_sequence)
  summands = [1]

  choice_sequence.each_with_index do |choice, index|
    current_number = index + 2
    case choice
    when :plus
      summands << current_number
    when :minus
      summands << -current_number
    when :next
      summands[-1] = (summands.last.to_s + current_number.to_s).to_i
    end
  end

  summands
end

def sum_up(list_of_summands)
  list_of_summands.inject(&:+)
end

def display_sum(list_of_summands)
  display_string = ''

  list_of_summands.each do |summand|
    if summand > 0
      display_string << " + #{summand.abs}"
    else
      display_string << " - #{summand.abs}"
    end
  end
  display_string.slice!(0, 3) if display_string[0] == ' '

  display_string
end

def find_hits
  hits = []

  sequences = generate_all_choice_sequences
  sequences.each do |sequence|
    summands = generate_list_of_summands(sequence)
    hits << summands if sum_up(summands) == TARGET_SUM
  end

  hits
end

def display_hits(hits)
  hits.each { |hit| puts display_sum(hit) }
end

display_hits(find_hits)
