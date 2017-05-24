# solving tic tac toe

require 'benchmark'

SIZE = 3 # 3 for 3x3 game, 4 for 4x4 game
SLOTS = SIZE ** 2
AVAILABLE = ' '
INITIAL_STATE = (AVAILABLE * SLOTS).chars
P1 = 'X'
P2 = 'O'
PLAYERS = [P1, P2]
WIN_LINES3 = [
  [0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8],
  [0, 4, 8], [2, 4, 6]
]
WIN_LINES4 = [
  [0, 1, 2], [1, 2, 3], [4, 5, 6], [5, 6, 7], [8, 9, 10], [9, 10, 11],
  [12, 13, 14], [13, 14, 15], [0, 4, 8], [4, 8, 12], [1, 5, 9], [5, 9, 13],
  [2, 6, 10], [6, 10, 14], [3, 7, 11], [7, 11, 15], [2, 5, 8], [3, 6, 9],
  [6, 9, 12], [7, 10, 13], [1, 6, 11], [0, 5, 10], [5, 10, 15], [4, 9, 14]
]

def terminal?(state)
  (PLAYERS.any? { |player| winner?(player, state) }) || full?(state)
end

def payoff(player, state)
  winner?(player, state) ? 1 : (winner?(opponent(player), state) ? -1 : 0)
end

def opponent(player)
  player == P1 ? P2 : P1
end

def winner?(player, state)
  win_lines.any? { |line| line.all? { |index| state[index] == player } }
end

def win_lines
  SIZE == 3 ? WIN_LINES3 : WIN_LINES4
end

def full?(state)
  available_moves(state).empty?
end

def available_moves(state)
  (0...SLOTS).select { |move| state[move] == AVAILABLE }
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
  state.each_slice(SIZE) { |slice| puts slice.join(' ') }
  puts history.join(' --> ')
end

# random choice
def random_choice(player, state, top)
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

# brute force negamax: returns move for the top-level call
def nega_max(player, state, top = false)
  if terminal?(state)
    return payoff(player, state)
  else
    best = available_moves(state).map do |move|
      state[move] = player
      value = -(nega_max(opponent(player), state))
      state[move] = AVAILABLE
      [move, value]
    end.max_by { |move, value| value }
    top ? best.first : best.last
  end
end

# ----- MEMOIZE VALUES

# TRANSPOSITION: avoids recomputing values for states that can be reached in several ways

# negamax with transposition table: returns move for the top-level call

# version 1:
# def nega_max_memo(player, state, top = false, table = {})
#   if table[state.join]
#     table[state.join]
#   elsif terminal?(state)
#     table[state.join] = payoff(player, state)
#   else
#     best = available_moves(state).map do |move|
#       state[move] = player
#       value = -nega_max_memo(opponent(player), state, false, table)
#       state[move] = AVAILABLE
#       [move, value]
#     end.max_by { |move, value| value }
#     top ? best.first : table[state.join] = best.last
#   end
# end

# version 2
def nega_max_memo(player, state, top = false, table = {})
  unless table[state.join]
    if terminal?(state)
      table[state.join] = payoff(player, state)
    else
      best = available_moves(state).map do |move|
        state[move] = player
        value = -nega_max_memo(opponent(player), state, false, table)
        state[move] = AVAILABLE
        [move, value]
      end.max_by { |move, value| value }
      top ? (return best.first) : table[state.join] = best.last
    end
  end
  table[state.join]
end

# SYMMETRIES: tic tac toe has 7 symmetries. computing one value, we get seven more "for free" (mathematically speaking).

# rotation by 90 degrees
def rotate90(state)
  state.each_slice(SIZE).reverse_each.to_a.transpose.flatten
end

# rotation by 180 degrees
def rotate180(state)
  state.reverse
end

# rotation by 270 degrees
def rotate270(state)
  rotate90(rotate180(state))
end

# reflection across the main diagonal
def transpose(state)
  state.each_slice(SIZE).to_a.transpose.flatten
end

# reflection across the counter diagonal
def reflect_sec_diag(state)
  transpose(rotate180(state))
end

# reflection across the horizontal
def reflect_horizontal(state)
  state.each_slice(SIZE).reverse_each.to_a.flatten
end

# reflection across the vertical
def reflect_vertical(state)
  state.each_slice(SIZE).flat_map(&:reverse)
end

# two approaches to taking symmetry into account:
# (1) when doing the lookup in our transposition table, check whether the values of symmetric states have already been computed.
# (2) when storing a value in the transposition table, store the values for all symmetric states along with it.

# -- approach 1: "complex lookup"

# => `look_up_value` returns the first truthy value
def look_up_value(state, table)
  table[state.join] ||
  table[rotate90(state).join] ||
  table[rotate180(state).join] ||
  table[rotate270(state).join] ||
  table[transpose(state).join] ||
  table[reflect_sec_diag(state).join] ||
  table[reflect_horizontal(state).join] ||
  table[reflect_vertical(state).join]
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
    top ? best.first : table[state.join] = best.last
  end
end

# TODO: is there a way to make this read nicer?

# -- approach 2: "make the table larger, keep the lookup simple"

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

# # version 1:
# def nega_max_sym_save(player, state, top = false, table = {})
#   if table[state.join]
#     table[state.join]
#   elsif terminal?(state)
#     save_value(table, state, payoff(player, state))
#     payoff(player, state)
#   else
#     best = available_moves(state).map do |move|
#       state[move] = player
#       value = -nega_max_sym_save(opponent(player), state, false, table)
#       state[move] = AVAILABLE
#       [move, value]
#     end.max_by { |move, value| value }
#     if top
#       best.first
#     else
#       save_value(table, state, best.last)
#       best.last
#     end
#   end
# end

# version 2
def nega_max_sym_save(player, state, top = false, table = {})
  unless table[state.join]
    if terminal?(state)
      save_value(table, state, payoff(player, state))
    else
      best = available_moves(state).map do |move|
        state[move] = player
        value = -nega_max_sym_save(opponent(player), state, false, table)
        state[move] = AVAILABLE
        [move, value]
      end.max_by { |move, value| value }
      top ? (return best.first) : save_value(table, state, best.last)
    end
  end
  table[state.join]
end

## PRUNING

## -- do not calculate subtrees that are not going to be played (assuming rational play)

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

## 3x3 board

player = 'X'
state = INITIAL_STATE
Benchmark.bmbm do |x|
#   x.report("rand  ") { select_move(:random_choice, player, state) }
#   x.report("bf    ") { select_move(:nega_max, player, state) }
  x.report("memo  ") { select_move(:nega_max_memo, player, state) }
  x.report("lookup") { select_move(:nega_max_sym_lookup, player, state) }
  x.report("save  ") { select_move(:nega_max_sym_save, player, state) }
  x.report("ab    ") { select_move(:alpha_beta, player, state) }
end

=begin

             user     system      total        real
rand     0.000000   0.000000   0.000000 (  0.000019)
bf       6.370000   0.010000   6.380000 (  6.397314)
memo     0.110000   0.000000   0.110000 (  0.102984)
lookup   0.050000   0.000000   0.050000 (  0.055518)
save     0.050000   0.000000   0.050000 (  0.042032)
ab       0.210000   0.000000   0.210000 (  0.209102)

-> memoizing values is a dramatic improvement over brute force negamax
-> exploiting symmetries allows us reduce computation time by half
-> saving symmetric values as we compute them seems slightly faster than computing symmetries during lookup (but it's hard to tell, really)
-> the memoization approaches are quite a bit faster than alpha-beta-search
-> it looks like alpa-beta scales a lot better, viz the results for a 4x4 board

=end

## 4x4 board

# player = 'X'
# state = INITIAL_STATE
# Benchmark.bmbm do |x|
#   x.report("memo  ") { select_move(:nega_max_memo, player, state) }
#   x.report("save  ") { select_move(:nega_max_sym_save, player, state) }
#   x.report("ab    ") { select_move(:alpha_beta, player, state) }
# end

=begin

             user     system      total        real
memo   521.060000   3.970000 525.030000 (530.018356)
save   143.150000   3.460000 146.610000 (149.428082)
ab      26.680000   0.060000  26.740000 ( 26.813583)

-> on a 4x4 board, ab pruning is far superior to memoization.
-> pruning as a necessary approach of any attempt to obtain a playable game.

=end

# ---- Putting up a fight

# payoff method that favors long plays over short ones:

# def move_count(state)
#   SLOTS - available_moves(state).count
# end

# def payoff(player, state)
#   if winner?(player, state)
#     100 - move_count(state)
#   elsif winner?(opponent(player), state)
#     -100 + move_count(state)
#   else
#     0
#   end
# end
