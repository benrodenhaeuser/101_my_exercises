# place n queens on a n by n board so that no queen attacks any of the others

require 'benchmark'

SIZE = 8

# ----------------------------------------------------------------------------
# SOLUTION 1
# ----------------------------------------------------------------------------

# data structure: matrix, i.e., a nested array represents the chess board

# approach:
#   - only carry out locally viable moves, taking into account which squares on
#     the board are already covered by some queen.
#   - a solution is obtained once SIZE queens are placed on the board.

# very complicated solution!

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

def open_diff_diag?(board, row_idx, col_idx)
  (0...SIZE).all? do |row|
    (0...SIZE).all? do |col|
      if row - col == row_idx - col_idx
        board[row][col] == OPEN_SQUARE
      else
        true
      end
    end
  end
end

def open_sum_diag?(board, row_idx, col_idx)
  (0...SIZE).all? do |row|
    (0...SIZE).all? do |col|
      if row + col == row_idx + col_idx
        board[row][col] == OPEN_SQUARE
      else
        true
      end
    end
  end
end

def slots(board)
  slots = []
  (0...SIZE).each do |row_idx|
    (0...SIZE).each do |col_idx|
      slots << [row_idx, col_idx]
    end
  end
  slots
end

def unattacked?(board, row_idx, col_idx)
  open_row?(board, row_idx) &&
  open_column?(board, col_idx) &&
  open_diff_diag?(board, row_idx, col_idx) &&
  open_sum_diag?(board, row_idx, col_idx)
end

def unattacked_slots(board)
  slots(board).select do |row_idx, col_idx|
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

# board = initialize_board
# p unattacked_slots(board)
# p available_slots(board)
# p open_diff_diag?(board, 1, 1)
# p open_sum_diag?(board, 1, 1)


# ----------------------------------------------------------------------------
# SOLUTION 2:
# ----------------------------------------------------------------------------

# solution 1 is very complex. this seems to be due to the choice of data structure for representing the problem domain.

# here, we explore another option: represent the problem by means of a flat array recording the positioning of the queens. every queen corresponds to one array element.

# a queen's row is given by the array index
# a queen's column is given by the value at the array index

# this changes the representation of the problem constraints:

# row not covered <=> automatically satisfied
# col not covered <=> choose number not yet contained in array
# diagonals not covered <=> check using sums/differences of index and value

def non_covered_col?(queens, new_queen)
  queens.all? do |queen|
    queen != new_queen
  end
end

def non_covered_diff_diag?(queens, new_queen)
  queens.all? do |queen|
    queen - queens.index(queen) != new_queen - queens.size
  end
end

def non_covered_sum_diag?(queens, new_queen)
  queens.all? do |queen|
    queen + queens.index(queen) != new_queen + queens.size
  end
end

def viable_choices2(queens)
  (0...SIZE).select do |choice|
    non_covered_col?(queens, choice) && non_covered_diff_diag?(queens, choice) &&
    non_covered_sum_diag?(queens, choice)
  end
end

def solve2(queens = [], solutions = [])
  return solutions << queens.inspect if queens.size == SIZE
  viable_choices2(queens).each do |choice|
    queens << choice
    solve2(queens, solutions)
    queens.pop
  end
  solutions
end

# ----------------------------------------------------------------------------
# SOLUTION 3: refactor solution 2
# ----------------------------------------------------------------------------

# this improves on solution 2 by making it more readable.
# the idea is to pull out the negation.
# instead of negations all over the place, we just have it in one place:
#
# a new queen is a viable choice if it does not attack any of the queens
# already on the board.
#
# also, we iterate over the array of queens placed so far only once instead of # three times (on each occasion)

def solve3(queens = [], solutions = [])
  if queens.size == SIZE
    solutions << queens.inspect
  else
    viable_choices3(queens).each do |new_queen|
      queens << new_queen
      solve3(queens, solutions)
      queens.pop
    end
  end
  solutions
end

def attack3?(queens, new_queen)
  queens.any? do |queen|
    queen == new_queen ||
    queen - queens.index(queen) == new_queen - queens.size ||
    queen + queens.index(queen) == new_queen + queens.size
  end
end

def viable_choices3(queens)
  (0...SIZE).select do |new_queen|
    !attack3?(queens, new_queen)
  end
end

# ----------------------------------------------------------------------------
# SOLUTION 3a: a small variation on solution 3
# ----------------------------------------------------------------------------

# we can also push the conditional *inside* the `each` loop:

def solve3a(queens = [], solutions = [])
  viable_choices3(queens).each do |new_queen|
    queens << new_queen
    if queens.size == SIZE
      solutions << queens.inspect # we are done
    else
      solve3a(queens, solutions) # keep going
    end
    queens.pop
  end
  solutions
end

# if there are no viable choices (i.e., we are stuck with less than eight queens), then the call will be rather trivial, it will simply return `solutions` as it was before the call.

# the advantage of this approach is that we avoid one redundant layer of method calls. while this won't make a lot of difference, this seems preferable.

# ----------------------------------------------------------------------------
# SOLUTION 4: memoize covered squares
# ----------------------------------------------------------------------------

# to avoid having to compute non-attacks all the time, we memoize the currently
# covered columns and diagonals in a hash

def solve4(queens = [], covered = init_covered, solutions = [])
  viable_choices(covered, queens.size).each do |new_queen|
    add_to_covered(covered, queens.size, new_queen)
    queens << new_queen
    if queens.size == SIZE
      solutions << queens.inspect
    else
      solve4(queens, covered, solutions)
    end
    queens.pop
    remove_from_covered(covered, queens.size, new_queen)
  end
  solutions
end

def viable_choices(covered, row)
  (0...SIZE).select do |col|
    !covered[:cols][col] &&
    !covered[:sum_diags][row + col] &&
    !covered[:diff_diags][row - col]
  end
end

def init_covered
  cols = (0..SIZE - 1).map { |col| [col, false] }.to_h
  sum_diags = (0..2*(SIZE - 1)).map { |diag| [diag, false] }.to_h
  diff_diags = (-(SIZE - 1)..SIZE - 1).map { |diag| [diag, false] }.to_h

  {
    cols: cols,
    sum_diags: sum_diags,
    diff_diags: diff_diags
  }
end

def add_to_covered(covered, row, col)
  covered[:cols][col] = true
  covered[:sum_diags][row + col] = true
  covered[:diff_diags][row - col] = true
end

def remove_from_covered(covered, row, col)
  covered[:cols][col] = false
  covered[:sum_diags][row + col] = false
  covered[:diff_diags][row - col] = false
end

# ----------------------------------------------------------------------------
# BENCHMARKS:
# ----------------------------------------------------------------------------

# NOTE:
# - the solve1 method from solution 1 is too slow to be interesting.
# - the solve3a method is more or less the same as solve3, so we omit it here.

# puts Benchmark.realtime { p solve2.size }
# puts Benchmark.realtime { p solve3.size }
# puts Benchmark.realtime { p solve4.size }

# 8x8 board:
# solve2: 0.01819799980148673
# solve3: 0.016749999951571226
# solve4: 0.005625000223517418

# 10x10 board:
# solve2: 0.39056000020354986
# solve3: 0.29880600003525615
# solve4: 0.0982429999858141

# 12x12 board:
# solve2: 14.65682000014931
# solve3: 10.745362000074238
# solve4:  2.664822000078857

# 14x14 board:
# solve2: 642.9831059998833
# solve3: 480.1802369998768
# solve4:  94.39550500037149

# Observations:
#
# - Solution 3 improves on solution 2 mainly in cutting down the number of
#   times we walk through the array of queens placed on the board so far (I
#   think).
# - Memoization has a quite dramatic effect on performance as the input size
#   grows.

# ----------------------------------------------------------------------------
# FURTHER EXPLORATION:
# ----------------------------------------------------------------------------

#   - additional optimization: symmetry breaking
#   - different algorithm: "iterative repair"
#   - a different task: find a *single* solution in linear time
#   - solve the problem on a modular chess board (i.e., a torus/donut)
