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

# ----- MEMOIZE VALUES

# store values that have been computed already

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

# ----- EXPLOIT SYMMETRIES

def column(state, index)
  state.each_slice(LINE_LENGTH).map { |slice| slice[index] }
end

# rotation by 90 degrees
def rotate90(state)
  (0...LINE_LENGTH).flat_map { |index| column(state, index).reverse }
end

# rotation by 180 degrees
def rotate180(state)
  state.reverse
end

# rotation by 270 degrees
def rotate270(state)
  (LINE_LENGTH - 1).downto(0).flat_map { |index| column(state, index) }
end

# reflection across main diagonal
def transpose(state)
  (0...LINE_LENGTH).flat_map { |index| column(state, index) }
end

# reflection across secondary diagonal
def reflect_sec_diag(state)
  (LINE_LENGTH - 1).downto(0).flat_map { |index| column(state, index).reverse }
end

# reflection across the horizontal
def reflect_horizontal(state)
  state.each_slice(LINE_LENGTH).reverse_each.to_a.flatten
end

# reflection across the vertical
def reflect_vertical(state)
  state.each_slice(LINE_LENGTH).flat_map { |slice| slice.reverse }
end

# APPROACH 1: make the table lookup more complex

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

# APPROACH 2: save more values to table (lookup remains simple)

def save_value(table, state, value)
  table[state.join] = value
  table[rotate90(state).join] = value
  table[rotate180(state).join] = value
  table[rotate270(state).join] = value
  table[transpose(state).join] = value
  table[reflect_sec_diag(state).join] = value
  table[reflect_horizontal(state).join] = value
  table[reflect_vertical(state).join] = value
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
Benchmark.bmbm { |x|
   x.report("bf    ") { select_move(:nega_max, player, state) }
   x.report("memo  ") { select_move(:nega_max_memo, player, state) }
   x.report("lookup") { select_move(:nega_max_sym_lookup, player, state) }
   x.report("save  ") { select_move(:nega_max_sym_save, player, state) }
   x.report("ab    ") { select_move(:alpha_beta, player, state) }
 }

#              user     system      total        real
# bf       6.870000   0.020000   6.890000 (  6.956717)
# memo     0.110000   0.000000   0.110000 (  0.103978)
# lookup   0.060000   0.000000   0.060000 (  0.058854)
# save     0.050000   0.000000   0.050000 (  0.052267)
# ab       0.220000   0.000000   0.220000 (  0.219942)

# -> so the "save" approach cuts down the time in half (almost)
# -> the "lookup" approach is almost as fast
# -> sensitive to "primitive" operations (using to_s instead of join to save to hash neutralizes the speed gain (I think)!)
# -> this raises the question if we could improve it by implementing the symmetries faster, and perhaps memoizing faster?

## OLD STUFF (unlikely to run anymore)

# display(play(:best_move_memo, 'O', 'XO  X    '.chars))

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
