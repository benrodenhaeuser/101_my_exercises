# solving tic tac toe

require 'benchmark'

LINE_LENGTH = 3 # 3 or 4
BOARD_SIZE = LINE_LENGTH ** 2
AVAILABLE = ' '
P1 = 'X'
P2 = 'O'
PLAYERS = [P1, P2]
INITIAL_STATE = (AVAILABLE * BOARD_SIZE).chars

def win_lines
  case LINE_LENGTH
  when 3
    [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ]
  when 4
    [
      [0, 1, 2], [1, 2, 3], [4, 5, 6], [5, 6, 7], [8, 9, 10], [9, 10, 11],
      [12, 13, 14], [13, 14, 15], [0, 4, 8], [4, 8, 12], [1, 5, 9], [5, 9, 13],
      [2, 6, 10], [6, 10, 14], [3, 7, 11], [7, 11, 15], [2, 5, 8], [3, 6, 9],
      [6, 9, 12], [7, 10, 13], [1, 6, 11], [0, 5, 10], [5, 10, 15], [4, 9, 14]
    ]
  end
end

def terminal?(state)
  (PLAYERS.any? { |player| winner?(player, state) }) || no_moves?(state)
end

def payoff(player, state)
  winner?(player, state) ? 1 : (winner?(opponent(player), state) ? -1 : 0)
end

def move_count(state)
  BOARD_SIZE - available_moves(state).size
end

def opponent(player)
  player == P1 ? P2 : P1
end

def winner?(player, state)
  win_lines.any? { |line| line.all? { |index| state[index] == player } }
end

def no_moves?(state)
  available_moves(state).empty?
end

def available_moves(state)
  (0...BOARD_SIZE).select { |move| state[move] == AVAILABLE }
end

def select_move(method, player, state)
  send(method, player, state, :top)
end

def play(method, player = P1, state = INITIAL_STATE)
  history = []
  loop do
    break if terminal?(state)
    move = select_move(method, player, state)
    history << move
    state[move] = player
    player = opponent(player)
  end
  [history, state]
end

def display(history, state)
  state.each_slice(LINE_LENGTH) { |slice| puts slice.join(' ') }
  puts history.join(' --> ')
end

# random choice (notice that the signature does not fit the earlier setup!)
def random_choice(player, state)
  available_moves(state).sample
end

# brute force negamax: returns the VALUE of the calling state
def value(player, state)
  if terminal?(state)
    payoff(player, state)
  else
    values = available_moves(state).map do |move|
      state[move] = player
      value = -value(opponent(player), state)
      state[move] = AVAILABLE
      value
    end
    values.max
  end
end

# brute force negamax: value/move
def nega_max(player, state, top = false)
  return payoff(player, state) if terminal?(state)
  best = available_moves(state).map do |move|
    state[move] = player
    value = -(nega_max(opponent(player), state))
    state[move] = AVAILABLE
    [move, value]
  end.max_by { |move, value| value }
  top ? best.first : best.last
end

# negamax with transposition table: value/move
def nega_max_memo(player, state, top = false, table = {})
  if table[state.join]
    table[state.join]
  elsif terminal?(state)
    table[state.join] = payoff(player, state)
  else
    best = available_moves(state).map do |move|
      state[move] = player
      value = -nega_max_memo(opponent(player), state, false, table)
      state[move] = AVAILABLE
      [move, value]
    end.max_by { |move, value| value }
    top ? best.first : table[state.join] = best.last
  end
end

# ----- Exploit symmetries

def column(state, index)
  state.each_slice(LINE_LENGTH).map { |slice| slice[index] }
end

def rotate90(state)
  (0...LINE_LENGTH).flat_map { |index| column(state, index).reverse }
end

def rotate180(state)
  state.reverse
end

def rotate270(state)
  rotate90(rotate180(state))
end

def reflect_horizontal(state)
  state.each_slice(LINE_LENGTH).reverse_each.to_a.flatten
end

def reflect_vertical(state)
  state.each_slice(LINE_LENGTH).map { |slice| slice.reverse }.flatten
end

# reflection across main diagonal
def transpose(state)
  (0...LINE_LENGTH).flat_map { |index| column(state, index) }
end

def reflect_sec_diag(state)
  reflect_horizontal(rotate90(state))
end

# table = { '  X      ' => 0 }
# p find_value('X        '.chars, table)
# p find_value('      X  '.chars, table)

# first approach: save values to table as before, do more complex lookups

# => `find_value` returns the first truthy value
def look_up_value(state, table)
  table[state.join] || table[transpose(state).join] || table[rotate180(state).join] || table[reflect_horizontal(state).join] || table[reflect_vertical(state).join] || table[rotate90(state).join] || table[rotate270(state).join] || table[reflect_sec_diag(state).join]
end

def nega_max_sym_lookup(player, state, top = false, table = {})
  value = look_up_value(state, table)
  if value
    return value
  elsif terminal?(state)
    table[state.join] = payoff(player, state)
  else
    best = available_moves(state).map do |move|
      state[move] = player
      value = -nega_max_sym_lookup(opponent(player), state, false, table)
      state[move] = AVAILABLE
      [move, value]
    end.max_by { |move, value| value }
    if top
      then best.first
    else
      table[state.join] = best.last
    end
  end
end

# second approach: make the table bigger, keep the lookup simple (intuition: this should be faster?)

def save_value(table, state, value)
  table[state.join] = value
  table[transpose(state).join] = value
  table[rotate180(state).join] = value
  table[reflect_horizontal(state).join] = value
  table[reflect_vertical(state).join] = value
  table[rotate90(state).join] = value
  table[rotate270(state).join] = value
  table[reflect_sec_diag(state).join] = value
end

def nega_max_sym_save(player, state, top = false, table = {})
  if table[state.join]
    table[state.join]
  elsif terminal?(state)
    save_value(table, state, payoff(player, state))
    payoff(player, state)
  else
    best = available_moves(state).map do |move|
      state[move] = player
      value = -nega_max_sym_save(opponent(player), state, false, table)
      state[move] = AVAILABLE
      [move, value]
    end.max_by { |move, value| value }
    if top
      then best.first
    else
      save_value(table, state, best.last)
      best.last
    end
  end
end


## ALPHA BETA

def alpha_beta(player, state, top = false, alpha = -10, beta = 10)
  if terminal?(state)
    payoff(player, state)
  else
    best = [nil, -10]
    available_moves(state).each do |move|
      state[move] = player
      value = [move, -alpha_beta(opponent(player), state, false, -beta, -alpha)]
      state[move] = AVAILABLE
      best = value if value.last > best.last
      alpha = [alpha, value.last].max
      break if alpha >= beta
    end
    top ? best.first : best.last
  end
end


# benchmarks

player = 'X'
state = INITIAL_STATE
puts Benchmark.realtime { select_move(:nega_max, player, state)  }
puts Benchmark.realtime { select_move(:nega_max_memo, player, state)  }
puts Benchmark.realtime { select_move(:nega_max_sym_lookup, player, state)  }
puts Benchmark.realtime { select_move(:nega_max_sym_save, player, state)  }
puts Benchmark.realtime { select_move(:alpha_beta, player, state)  }

# evaluating nega_max, nega_max_memo, nega_max_memo_sym_lookup, nega_max_memo_save, alpha_beta
# 6.63122499990277
# 0.10882199998013675 # => dramatic improvement
# 0.06530999997630715
# 0.05884400010108948 # => twice as fast as simple memoization
# 0.2322039999999106 # => a lot slower


# evaluating nega_max_memo, nega_max_sym_lookup and nega_max_sym_save:

# with 3 symmetries:
# 0.1149260001257062
# 0.0848910000640899
# 0.07703999988734722

# with 4 symmetries:
# 0.11069700005464256
# 0.07320600003004074
# 0.0637389998883009

# with 5 symmetries:
# 0.10677900002337992
# 0.08197399997152388
# 0.062005999963730574

# with 6 symmetries:
# 0.1030689999461174
# 0.07358300010673702
# 0.06651999987661839

# with 7 symmetries:
# 0.107700000051409
# 0.06704799993894994
# 0.05957600008696318

# -> so the save approach cuts down the time in half (almost)
# -> very sensitive to "primitive" operations (using to_s instead of join to save to hash neutralizes the speed gain!)

## OLD STUFF (unlikely to run anymore)

# display(play(:best_move_memo, 'O', 'XO  X    '.chars))

# on a 3x3 board
# p best_move_prune
# puts Benchmark.realtime{ display(play(:best_move_prune)) }
# {:value=>0, :move=>0}
# X X O
# O O X
# X O X
# 0.26510000019334257

# on a 4x4 board
# p best_move_prune

# {:value=>1, :move=>0}
# X O O X
# X O
# X
#
# 45.212250999873504

# ^ this looks odd! ... what is going on?

# board = (AVAILABLE * BOARD_SIZE).chars
# board[0] = 'X'
# p best_move_prune('O', board) # => {:value=>-1, :move=>1}

# ^ right. the problem is that the 'O' player just picks a move that leads to a loss ... because all moves lead to a loss.

# we could try to fix this by giving better values to long losses over short losses => picking up a fight is encouraged.

# display(play(:best_move_prune))

# puts Benchmark.realtime { value }
# puts Benchmark.realtime { best_move }
# puts Benchmark.realtime { value_memo }
# puts Benchmark.realtime { best_move_memo }
# puts Benchmark.realtime { best_move_reflect }
# 5.490661000134423
# 6.565301000140607
# 0.08823299990035594
# 0.11649300018325448
# 0.08672400005161762
# 0.0003179998602718115

# puts Benchmark.realtime { play(:best_move_memo) }
# puts Benchmark.realtime { play(:best_move_reflect) }

# 0.17226799996569753
# 1.00000761449337e-05 ??
# 7.999828085303307e-06 ??

# TODO:
# - cut down computation time by using insights about the game: symmetries
# - alpha-beta-pruning
# - get more interesting play on 4x4 board? ... watching computers play a solved game is boring


# ---- Putting up a fight

# payoff method that favors long plays over short ones:

# def payoff(player, state)
#   if winner?(player, state)
#     100 - move_count(state)
#   elsif winner?(opponent(player), state)
#     -100 + move_count(state)
#   else
#     0
#   end
# end
