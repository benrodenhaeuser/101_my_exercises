# place n queens on a n by n board so that no queen attacks any of the others

SIZE = 8
OPEN = 0
QUEEN = 1

def initialize_board
  row = []
  SIZE.times { row << OPEN }
  board = []
  SIZE.times { board << row.clone }
  board
end

def open_row?(board, row_idx)
  board[row_idx].all? { |elem| elem == OPEN }
end

def open_column?(board, col_idx)
  board.all? { |row| row[col_idx] == OPEN }
end

def open_up_diag?(board, row_idx, col_idx)
  up_diag_slots = get_up_diag_slots(board, row_idx, col_idx)
  up_diag_slots.all? { |row_idx, col_idx| board[row_idx][col_idx] == OPEN }
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

def open_down_diag?(board, row_idx, col_idx)
  down_diag_slots = get_down_diag_slots(board, row_idx, col_idx)
  down_diag_slots.all? { |row_idx, col_idx| board[row_idx][col_idx] == OPEN }
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
  (0...SIZE).each do |row|
    (0...SIZE).each do |col|
      slots << [row, col] if board[row][col] == OPEN
    end
  end
  slots
end

def consistent_choices(board)
  open_slots(board).select do |row_idx, col_idx|
    open_row?(board, row_idx) &&
    open_column?(board, col_idx) &&
    open_up_diag?(board, row_idx, col_idx) &&
    open_down_diag?(board, row_idx, col_idx)
  end
end

def make_move(board, row_idx, col_idx)
  board[row_idx][col_idx] = QUEEN
end

def unmake_move(board, row_idx, col_idx)
  board[row_idx][col_idx] = OPEN
end

def find_solution(board, number_of_choices = 0, solutions = [])
  solutions << board.inspect if number_of_choices == SIZE
  consistent_choices(board).each do |row_idx, col_idx|
    return solutions if solutions != []
    make_move(board, row_idx, col_idx)
    number_of_choices += 1
    find_solution(board, number_of_choices, solutions)
    unmake_move(board, row_idx, col_idx)
    number_of_choices -= 1
  end
  nil
end

find_solution(initialize_board)[0]

# 4 by 4:
#
# [0, 1, 0, 0]
# [0, 0, 0, 1]
# [1, 0, 0, 0]
# [0, 0, 1, 0]
#
# 0.00051099993288517 seconds

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
# 1.9962479998357594 seconds
