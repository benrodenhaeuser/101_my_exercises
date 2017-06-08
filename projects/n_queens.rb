# place n queens on a n by n board so that no queen attacks any of the others

require 'benchmark'

SIZE = 8


# SOLUTION 1

OPEN_SQUARE = 0
QUEEN_SQUARE = 1

def initialize_board
  (0...SIZE).map do |row|
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

def open_up_diag?(board, row_idx, col_idx)
  up_diag_slots = get_up_diag_slots(board, row_idx, col_idx)
  up_diag_slots.all? { |row_idx, col_idx| board[row_idx][col_idx] == OPEN_SQUARE }
end

# tedious!
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

# tedious! 
def open_down_diag?(board, row_idx, col_idx)
  down_diag_slots = get_down_diag_slots(board, row_idx, col_idx)
  down_diag_slots.all? { |row_idx, col_idx| board[row_idx][col_idx] == OPEN_SQUARE }
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

def open_slots(board)
  slots = []
  (0...SIZE).each do |row_idx|
    (0...SIZE).each do |col_idx|
      slots << [row_idx, col_idx] if board[row_idx][col_idx] == OPEN_SQUARE
    end
  end
  slots
end

def constrained_choices(board)
  open_slots(board).select do |row_idx, col_idx|
    open_row?(board, row_idx) &&
    open_column?(board, col_idx) &&
    open_up_diag?(board, row_idx, col_idx) &&
    open_down_diag?(board, row_idx, col_idx)
  end
end

def make_move(board, row_idx, col_idx)
  board[row_idx][col_idx] = QUEEN_SQUARE
end

def unmake_move(board, row_idx, col_idx)
  board[row_idx][col_idx] = OPEN_SQUARE
end

def find_a_solution(board, number_of_choices = 0, solutions = [])
  solutions << board.inspect if number_of_choices == SIZE
  constrained_choices(board).each do |row_idx, col_idx|
    return solutions if solutions != []
    make_move(board, row_idx, col_idx)
    number_of_choices += 1
    find_a_solution(board, number_of_choices, solutions)
    unmake_move(board, row_idx, col_idx)
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

# SOLUTION 2: use a simpler data structure

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

def distinct_main_diag?(queens, new_queen)
  queens.all? do |queen|
    queen - queens.index(queen) != new_queen - queens.size
  end
end

def distinct_counter_diag?(queens, new_queen)
  queens.all? do |queen|
    queen + queens.index(queen) != new_queen + queens.size
  end
end

def constrained_choices(queens)
  constrained_choices = []
  (0...SIZE).select do |choice|
    distinct_col?(queens, choice) && distinct_main_diag?(queens, choice) &&
    distinct_counter_diag?(queens, choice)
  end
end

p generate_solutions.size # 92 => this is correct

# 8 by 8:
# 0.0013069999404251575

# 20 by 20:
# 8.46816199971363
