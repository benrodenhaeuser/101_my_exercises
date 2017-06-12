# place n queens on a n by n board so that no queen attacks any of the others

require 'benchmark'

SIZE = 12

# SOLUTION 1
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

def open_downward_diag?(board, row_idx, col_idx)
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

def find_a_solution(board, number_of_choices = 0, solutions = [])
  solutions << board.inspect if number_of_choices == SIZE
  unattacked_slots(board).each do |row_idx, col_idx|
    return solutions if solutions != []
    choose_slot(board, row_idx, col_idx)
    number_of_choices += 1
    find_a_solution(board, number_of_choices, solutions)
    unchoose_slot(board, row_idx, col_idx)
    number_of_choices -= 1
  end
  nil
end

# puts Benchmark.realtime { find_a_solution(initialize_board)[0] }

# 8 by 8:
#
# [1, 0, 0, 0, 0, 0, 0, 0]
# [0, 0, 0, 0, 1, 0, 0, 0]
# [0, 0, 0, 0, 0, 0, 0, 1]
# [0, 0, 0, 0, 0, 1, 0, 0]
# [0, 0, 1, 0, 0, 0, 0, 0]
# [0, 0, 0, 0, 0, 0, 1, 0]
# [0, 1, 0, 0, 0, 0, 0, 0]
# [0, 0, 0, 1, 0, 0, 0, 0]
#
# 1.9145939997397363 seconds (for one solution)

# SOLUTION 2:
# use a flat array to just represent the queens

# this changes the representation of the constraints:

# row is open <=> automatically satisfied
# col is open <=> "no element of array has value of col"
# diagonals: combination of index and value

def generate_solutions(queens = [], solutions = [])
  return solutions << queens.inspect if queens.size == SIZE
  constrained_choices(queens).each do |choice|
    queens << choice
    generate_solutions(queens, solutions)
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

# puts Benchmark.realtime {generate_solutions.size } # 92 => this is correct

# 8 by 8:
# 0.0013069999404251575

# 20 by 20:
# 8.46816199971363

# SOLUTION 3: refactor solution 2
# use an attack? method to model the problem more clearly

def attack?(queen1, queen2)
  queen1 == queen2 || # same col
  queens[queen1] + queen1 == queens[queen2] + queen2 # same sum diag
  queens[queen1] - queen1 == queens[queen2] = queen2 # same diff diag
end

def good_choices(queens)
  (0...SIZE).select do |choice|
    queens.all? { |queen| !attack?(queen, choice) }
  end
end

def solve(queens = [], solutions = [])
  return solutions << queens.inspect if queens.size == SIZE
  good_choices(queens).each do |choice|
    queens << choice
    generate_solutions(queens, solutions)
    queens.pop
  end
  solutions
end

puts Benchmark.realtime { p solve.size } # 92 => this is correct
# 8 by 8: 0.018118999898433685
# 10 by 10: 0.37390700029209256
# 11 by 11: 2.2709449999965727
# 12 by 12: 12.973269999958575

# SOLUTION 4:

# exhaustive search: go through all permutations one by one, check in the end whether they lead to valid solutions.

def solve(queens = [], solutions = [])
  return solutions << queens.inspect if queens.size == SIZE && valid?(queens)
  (0...SIZE).each do |choice|
    queens << choice
    generate_solutions(queens, solutions)
    queens.pop
  end
  solutions
end

def valid?(queen)
  solution.all? do |queen1|
    solution.all? do |queen2|
      !attack(queen1, queen2)
    end
  end
end

# puts Benchmark.realtime { p solve.size }
# => this is a little slower than solution 3, but just a little 
