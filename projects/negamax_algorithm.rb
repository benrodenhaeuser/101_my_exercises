# tic tac toe negamax algorithm

# bare bones tic tac toe

M1 = '1'; M2 = '2'; M3 = '3'
M4 = '4'; M5 = '5'; M6 = '6'
M7 = '7'; M8 = '8'; M9 = '9'

MOVES = [M1, M2, M3, M4, M5, M6, M7, M8, M9]

WIN_STRINGS = %r{
  #{M1}#{M2}#{M3}.*|.*#{M4}#{M5}#{M6}.*|.*#{M7}#{M8}#{M9}|
  #{M1}.*#{M4}.*#{M7}.*|.*#{M2}.*#{M5}.*#{M8}.*|.*#{M3}.*#{M6}.*#{M9}|
  #{M1}.*#{M5}.*#{M9}|.*#{M3}.*#{M5}.*#{M7}.*
}x

def initialize_board
  board = {}
  MOVES.each { |move| board[move] = false }
  board
end

def available_moves(board)
  MOVES.select { |move| !board[move] }
end

def moves_so_far_of(player, board)
  MOVES.select { |move| board[move] == player }
end

def full?(board)
  available_moves(board) == []
end

def empty?(board)
  available_moves(board) == MOVES
end

def update(board, move, player)
  board[move] = player
end

def undo(move, board)
  board[move] = false
end

def opponent_of(player)
  case player
  when :computer then :user
  when :user then :computer
  end
end

def winner?(board, player)
  !!moves_so_far_of(player, board).join.match(WIN_STRINGS)
end

def done?(board)
  winner?(board, :computer) || winner?(board, :user) || full?(board)
end

def result_for(player, board)
  if winner?(board, player)
    1
  elsif winner?(board, opponent_of(player))
    -1
  elsif full?(board)
    0
  end
end

# initial version: brute force negamax score function

def score(board, player)
  if done?(board)
    result_for(player, board)
  else
    next_scores = []
    available_moves(board).each do |move|
      update(board, move, player)
      next_scores << -score(board, opponent_of(player))
      undo(move, board)
    end
    next_scores.max
  end
end

# refactoring: negamax with memoization
# (stores solutions as a side effect)

def score(board, player, scores)
  return nil if scores[board]

  if done?(board)
    scores[board] = result_for(player, board)
  else
    next_scores = []
    available_moves(board).each do |move|
      update(board, move, player)
      score(board, opponent_of(player), scores)
      next_scores << -scores[board]
      undo(move, board)
      break if next_scores.last == 1
    end
    scores[board] = next_scores.max
  end

  nil
end

# adapt negamax so that it tracks the best move
# (stores solutions as a side effect)

def score(board, player, scores)
  return nil if scores[board]

  if done?(board)
    scores[board] = [result_for(player, board), nil]
  else
    next_scores = []
    available_moves(board).each do |move|
      update(board, move, player)
      score(board, opponent_of(player), scores)
      next_scores << [-scores[board].first, move]
      undo(move, board)
    end
    # select the score/move pair such that score is highest
    scores[board] = next_scores.max_by { |score, move| score }
  end

  nil
end

def get_unbeatable_move(board)
  scores = {}
  score(board, :computer, scores)
  scores[board].last
end


# maybe the following naming is better?

def evaluate(board, player, evaluated)
  return nil if evaluated[board]

  if done?(board)
    evaluated[board] = [result_for(player, board), nil]
  else
    next_scores = []
    available_moves(board).each do |move|
      update(board, move, player)
      evaluate(board, opponent_of(player), evaluated)
      next_scores << [-evaluated[board].first, move]
      undo(move, board)
    end
    evaluated[board] = next_scores.max_by { |score, move| score }
  end

  nil
end

def get_unbeatable_move(board)
  evaluated = {}
  score(board, :computer, evaluated)
  evaluated[board].last
end


# fixing the return value: we don't want the solutions just to be created as a side effect of calling the negamax method, we want the best move to be the return value of that method

def get_unbeatable_move(board)
  negamax(board).last
end

def negamax(board, player = :computer, evaluated = {})
  if evaluated[board]
    evaluated[board]
  elsif done?(board)
    evaluated[board] = [result_for(player, board), nil]
  else
    next_scores = []
    available_moves(board).each do |move|
      update(board, move, player)
      negamax(board, opponent_of(player), evaluated)
      next_scores << [-evaluated[board].first, move]
      undo(move, board)
    end
    evaluated[board] = next_scores.max_by { |score, move| score }
  end
end

# store individual board values as hashes of the form { score: x, move: y }

def get_optimal_move(board)
  negamax(board)
end

def negamax(board, player = :computer, best = {})
  return best[board][:move] if best[board]

  if done?(board)
    best[board] = { score: result_for(player, board), move: nil}
    nil # no move to make here!
  else
    current_options = []

    available_moves(board).each do |move|
      update(board, move, player)
      negamax(board, opponent_of(player), best) unless best[board]
      current_options << { score: -best[board][:score], move: move }
      undo(move, board)
    end

    best[board] = current_options.max_by { |option| option[:score] }
    best[board][:move]
  end
end

# without storage (for comparison)

def get_optimal_move(board)
  negamax(board)
end

def negamax(board, player = :computer, best = {})
  if done?(board)
    best[board] = { score: result_for(player, board), move: nil}
    nil
  else
    current_options = []

    available_moves(board).each do |move|
      update(board, move, player)
      negamax(board, opponent_of(player), best)
      current_options << { score: -best[board][:score], move: move }
      undo(move, board)
    end

    best[board] = current_options.max_by { |option| option[:score] }
    best[board][:move]
  end
end


# final naming

def get_best_move(board, player = :computer, best = {})
  return best[board][:move] if best[board]

  if done?(board)
    best[board] = { score: result_for(player, board), move: nil}
    nil
  else
    current_options = []

    available_moves(board).each do |move|
      update(board, move, player)
      get_best_move(board, opponent_of(player), best) unless best[board]
      current_options << { score: -best[board][:score], move: move }
      undo(move, board)
    end

    best[board] = current_options.max_by { |option| option[:score] }
    best[board][:move]
  end
end

# how about using map?

def solve(board, player, evaluation)
  return nil if evaluation[board]

  if done?(board)
    evaluation[board] = { score: result_for(player, board), move: nil }
  else
    options =
      available_moves(board).map do |move|
        update(board, move, player)
        solve(board, opponent_of(player), evaluation)
        option = { score: -evaluation[board][:score], move: move }
        undo(move, board)
        option
      end
    evaluation[board] = options.max_by { |option| option[:score] }
  end

  nil
end
#
# after_two_moves = {
#   '1' => false, '2' => :user, '3' => :computer,
#   '4' => :user, '5' => false, '6' => false,
#   '7' => false, '8' => false, '9' => false,
# }
#
# best = {}
#
# solve(after_two_moves, :computer, best)
#
# p best
# p best[after_two_moves]




# are we actually memoizing the board? the board keeps changing, so I am not sure why this is working at all.

# the following writes the board to a string before saving it in the array.

def solve(board)
  evaluation = {}
  solve(board, :computer, evaluation)
  evaluation[board.to_s][:move]
end

def solve(board, player, evaluation)
  return nil if evaluation[board.to_s]

  if done?(board)
    evaluation[board.to_s] = { score: result_for(player, board), move: nil }
  else
    options =
      available_moves(board).map do |move|
        update(board, move, player)
        solve(board, opponent_of(player), evaluation)
        option = { score: -evaluation[board.to_s][:score], move: move }
        undo(move, board)
        option
      end
    evaluation[board.to_s] = options.max_by { |option| option[:score] }
  end

  nil
end

after_two_moves = {
  '1' => false, '2' => :user, '3' => :computer,
  '4' => :user, '5' => false, '6' => false,
  '7' => false, '8' => false, '9' => false,
}

best = {}

solve(after_two_moves, :computer, best)

p best
p best[after_two_moves.to_s]


# test cases

initial_board = {
  '1' => false, '2' => false, '3' => false,
  '4' => false, '5' => false, '6' => false,
  '7' => false, '8' => false, '9' => false,
}

one_move_to_win_for_computer = {
  '1' => :computer, '2' => :computer, '3' => false,
  '4' => :user, '5' => false, '6' => false,
  '7' => :user, '8' => false, '9' => false,
}

terminal_board = {
  '1' => :computer, '2' => :computer, '3' => :computer,
  '4' => :user, '5' => false, '6' => false,
  '7' => :user, '8' => false, '9' => false,
}

after_two_moves = {
  '1' => false, '2' => :user, '3' => :computer,
  '4' => :user, '5' => false, '6' => false,
  '7' => false, '8' => false, '9' => false,
}

after_one_move = {
  '1' => false, '2' => false, '3' => false,
  '4' => :user, '5' => false, '6' => false,
  '7' => false, '8' => false, '9' => false,
}

# p get_computer_move(initial_board)
# board = after_one_move
# player = :computer
# scores = {}
# score(board, player, scores)
# p scores[board] # ca 4 seconds

# p score(terminal_board, :user) # - 1
# p score(one_move_to_win_for_computer, :computer) # 1
# p score(initial_board, :user)
# p score(after_two_moves, :computer) # 1
# p score(after_one_move, :computer) # 0

# p done?(initial_board) # false
# p done?(terminal_board) # true
# p winner?(terminal_board, :computer) # true
