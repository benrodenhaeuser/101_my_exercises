# place n queens on a n by n board so that no queen attacks any of the others

require 'benchmark'

SIZE = 10

# ----------------------------------------------------------------------------
# SOLUTION 1
# ----------------------------------------------------------------------------

# using a nested array representing the board as a data structure

# approach:
# we model the problem by considering a sequence of placement choices, i.e., each choice consists in placing a queen on the chess board.
# rather than considering random such choices, we only try choices that are locally consistent in the sense that they we do not place a queen in a square where it would attack another queen.

OPEN_SQUARE = 0
QUEEN_SQUARE = 1

def initialize_board
  (0...SIZE).map do
    (0...SIZE).map do
      OPEN_SQUARE
    end
  end
end

def open_row?(board, row_idx)
  board[row_idx].all? { |elem| elem == OPEN_SQUARE }
end

def open_column?(board, col_idx)
  board.all? { |row| row[col_idx] == OPEN_SQUARE }
end

def open_upwards_diag?(board, row_idx, col_idx)
  up_diag_slots = get_up_diag_slots(board, row_idx, col_idx)
  up_diag_slots.all? { |row_idx, col_idx| board[row_idx][col_idx] == OPEN_SQUARE }
end

def open_downwards_diag?(board, row_idx, col_idx)
  down_diag_slots = get_down_diag_slots(board, row_idx, col_idx)
  down_diag_slots.all? { |row_idx, col_idx| board[row_idx][col_idx] == OPEN_SQUARE }
end

def get_up_diag_slots(board, row_idx, col_idx)
  up_diag_slots = [[row_idx, col_idx]]
  stored_row_idx = row_idx
  stored_col_idx = col_idx

  while row_idx > 0 && col_idx < (SIZE - 1)
    row_idx -= 1
    col_idx += 1
    up_diag_slots << [row_idx, col_idx]
  end

  row_idx = stored_row_idx
  col_idx = stored_col_idx

  while row_idx < (SIZE - 1) && col_idx > 0
    row_idx += 1
    col_idx -= 1
    up_diag_slots << [row_idx, col_idx]
  end

  up_diag_slots
end

def get_down_diag_slots(board, row_idx, col_idx)
  down_diag_slots = [[row_idx, col_idx]]

  stored_row_idx = row_idx
  stored_col_idx = col_idx

  while row_idx > 0 && col_idx > 0
    row_idx -= 1
    col_idx -= 1
    down_diag_slots << [row_idx, col_idx]
  end

  row_idx = stored_row_idx
  col_idx = stored_col_idx

  while row_idx < (SIZE - 1) && col_idx < (SIZE - 1)
    row_idx += 1
    col_idx += 1
    down_diag_slots << [row_idx, col_idx]
  end

  down_diag_slots
end

def available_slots(board)
  slots = []
  (0...SIZE).each do |row_idx|
    (0...SIZE).each do |col_idx|
      slots << [row_idx, col_idx] if board[row_idx][col_idx] == OPEN_SQUARE
    end
  end
  slots
end

def unattacked?(board, row_idx, col_idx)
  open_row?(board, row_idx) &&
  open_column?(board, col_idx) &&
  open_upwards_diag?(board, row_idx, col_idx) &&
  open_downwards_diag?(board, row_idx, col_idx)
end

def unattacked_slots(board)
  available_slots(board).select do |row_idx, col_idx|
    unattacked?(board, row_idx, col_idx)
  end
end

def choose_slot(board, row_idx, col_idx)
  board[row_idx][col_idx] = QUEEN_SQUARE
end

def unchoose_slot(board, row_idx, col_idx)
  board[row_idx][col_idx] = OPEN_SQUARE
end

def solve1(board = initialize_board, number_of_choices = 0, solutions = [])
  return solutions << board.inspect if number_of_choices == SIZE
  unattacked_slots(board).each do |row_idx, col_idx|
    return solutions if solutions != []
    choose_slot(board, row_idx, col_idx)
    number_of_choices += 1
    solve1(board, number_of_choices, solutions)
    unchoose_slot(board, row_idx, col_idx)
    number_of_choices -= 1
  end
  solutions
end

# ----------------------------------------------------------------------------
# SOLUTION 2:
# ----------------------------------------------------------------------------

# use a flat array to represent the queens

# a queen's row is given by the array index
# a queen's column is given by the value at the array index

# this changes the representation of the constraints:

# row is open <=> automatically satisfied
# col is open <=> "no element of array has value of col"
# diagonals: combination of index and value (sum diagonal/diff diagonal)

def solve2(queens = [], solutions = [])
  return solutions << queens.inspect if queens.size == SIZE
  constrained_choices(queens).each do |choice|
    queens << choice
    solve2(queens, solutions)
    queens.pop
  end
  solutions
end

def distinct_col?(queens, new_queen)
  queens.all? do |queen|
    queen != new_queen
  end
end

def distinct_diff_diag?(queens, new_queen)
  queens.all? do |queen|
    queen - queens.index(queen) != new_queen - queens.size
  end
end

def distinct_sum_diag?(queens, new_queen)
  queens.all? do |queen|
    queen + queens.index(queen) != new_queen + queens.size
  end
end

def constrained_choices(queens)
  (0...SIZE).select do |choice|
    distinct_col?(queens, choice) && distinct_diff_diag?(queens, choice) &&
    distinct_sum_diag?(queens, choice)
  end
end


# ----------------------------------------------------------------------------
# SOLUTION 3: refactor solution 2
# ----------------------------------------------------------------------------

# use an attack? method to model the problem more clearly

# TODO: note that the index gives the row and the value at the index gives the column. our terminology does not properly reflect this, I think, i.e., sometimes the terminology suggests the indices are the queens, sometimes the terminology suggests the values are the queens.

def attack?(queens, queen1, queen2)
  unless queen1 == queen2 # same index, i.e., same queen
    queens[queen1] == queens[queen2] || # same col
    queens[queen1] + queen1 == queens[queen2] + queen2 || # same sum diag
    queens[queen1] - queen1 == queens[queen2] - queen2 # same diff diag
  end
end

def get_choices
  choice_hash = {}
  (0...SIZE).each do |choice|
    choice_hash[choice] = true
  end
  choice_hash
end

def good_choice?(queens)
  (0...queens.size).all? { |queen| !attack?(queens, queen, queens.size - 1) }
end

def solve3(queens = [], choices = get_choices, solutions = [])
  return solutions << queens.inspect if queens.size == SIZE
  choices.select { |choice, val| val == true }.each do |choice, _|
    queens << choice
    choices[choice] = false
    solve3(queens, choices, solutions) if good_choice?(queens)
    queens.pop
    choices[choice] = true
  end
  solutions
end

# ----------------------------------------------------------------------------
# SOLUTION 4:
# ----------------------------------------------------------------------------

# test diagonals only in the end

def attack?(queens, queen1, queen2)
  unless queen1 == queen2 # same index, i.e., same queen
    queens[queen1] == queens[queen2] || # same col
    queens[queen1] + queen1 == queens[queen2] + queen2 || # same sum diag
    queens[queen1] - queen1 == queens[queen2] - queen2 # same diff diag
  end
end

def solve4(queens = [], choices = get_choices, solutions = [])
  return solutions << queens.inspect if queens.size == SIZE && valid?(queens)
  choices.select { |choice, val| val == true }.each do |choice, _|
    queens << choice
    choices[choice] = false
    solve4(queens, choices, solutions)
    queens.pop
    choices[choice] = true
  end
  solutions
end

def get_choices
  choice_hash = {}
  (0...SIZE).each do |choice|
    choice_hash[choice] = true
  end
  choice_hash
end

def valid?(queens)
  (0...SIZE).all? do |queen1|
    (0...SIZE).all? do |queen2|
      !attack?(queens, queen1, queen2)
    end
  end
end

# ----------------------------------------------------------------------------

# puts Benchmark.realtime { p solve1.size }
# ^ 1.901837000157684 for a single solution!
# puts Benchmark.realtime { p solve2.size } # 0.018800999831408262
puts Benchmark.realtime { p solve3.size } # 0.010900000110268593 for 8x8
# puts Benchmark.realtime { p solve4.size } # 0.23814400006085634 for 8x8

# presumably, a lot of effort here goes into the attack? method.
# dijkstra discusses a way to memoize covered fields, something I had been thinking about initially, but couldn't find a good method to do it.
