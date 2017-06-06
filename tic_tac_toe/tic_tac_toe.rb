# tic tac toe

require 'benchmark'

# --------------------------------------------------------------------

# GAME

LENGTH = 3 # legal values: 3 (3x3 board), 4 (4x4 board)
SQUARES = LENGTH ** 2
AVAILABLE = ' '
INITIAL_STATE = (AVAILABLE * SQUARES).chars
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
  LENGTH == 3 ? WIN_LINES3 : WIN_LINES4
end

def full?(state)
  available_moves(state).empty?
end

def available_moves(state)
  (0...SQUARES).select { |move| state[move] == AVAILABLE }
end

def select_move(method, player, state)
  send(method, player, state, :top)
end

def make(move, player, state)
  state[move] = player
end

def unmake(move, state)
  state[move] = AVAILABLE
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
  state.each_slice(LENGTH) { |slice| puts slice.join(' ') }
  puts history.join(' --> ')
end

# --------------------------------------------------------------------

## ALGORITHMS

# brute force negamax
def nega_max_value(player, state)
  if terminal?(state)
    best_value = payoff(player, state)
  else
    best_value = available_moves(state).map do |move|
      make(move, player, state)
      value_for_move = -nega_max_value(opponent(player), state)
      unmake(move, state)
      value_for_move
    end.max
  end
  best_value
end

# brute force negamax: return *move* for the top-level call
def nega_max(player, state, top = false)
  if terminal?(state)
    best_value = payoff(player, state)
  else
    best = available_moves(state).map do |move|
      make(move, player, state)
      value_for_move = -(nega_max(opponent(player), state))
      unmake(move, state)
      [move, value_for_move]
    end.max_by { |move, value_for_move| value_for_move }
    top ? (return best.first) : best_value = best.last
  end
  best_value
end

# brute force negamax shortcut: return if we have found a tied subtree
def nega_max_shortcut(player, state, top = false)
  if terminal?(state)
    best_value = payoff(player, state)
  else
    pairs = []
    available_moves(state).each do |move|
      make(move, player, state)
      value_for_move = -(nega_max(opponent(player), state))
      unmake(move, state)
      pairs << [move, value_for_move]
      break if value_for_move >= 0
    end
    best = pairs.max_by { |move, value_for_move| value_for_move }
    top ? (return best.first) : best_value = best.last
  end
  best_value
end

# memoization: transposition table, **but return value always**
def nega_max_value(player, state, table)
  unless table[state.join]
    if terminal?(state)
      table[state.join] = payoff(player, state)
    else
      table[state.join] = available_moves(state).map do |move|
        make(move, player, state)
        value_for_move = -nega_max_value(opponent(player), state, table)
        unmake(move, state)
        value_for_move
      end.max
    end
  end
  table[state.join]
end

# memoization: transposition table
def nega_max_trans(player, state, top = false, table = {})
  unless table[state.join]
    if terminal?(state)
      table[state.join] = payoff(player, state)
    else
      best = available_moves(state).map do |move|
        make(move, player, state)
        value_for_move = -nega_max_trans(opponent(player), state, false, table)
        unmake(move, state)
        [move, value_for_move]
      end.max_by { |move, value_for_move| value_for_move }
      top ? (return best.first) : table[state.join] = best.last
    end
  end
  table[state.join]
end

# memoization: transposition table with SHORTCUT
def nega_max_trans_short(player, state, top = false, table = {})
  unless table[state.join]
    if terminal?(state)
      table[state.join] = payoff(player, state)
    else
      pairs = []
      available_moves(state).each do |move|
        make(move, player, state)
        value_for_move = -nega_max_trans(opponent(player), state, false, table)
        unmake(move, state)
        pairs << [move, value_for_move]
        break if value_for_move >= 0
      end
      best = pairs.max_by { |move, value_for_move| value_for_move }
      top ? (return best.first) : table[state.join] = best.last
    end
  end
  table[state.join]
end

# memoization: symmetry table
def nega_max_sym(player, state, top = false, table = {})
  unless table[state.join]
    if terminal?(state)
      save_values(table, state, payoff(player, state))
    else
      best = available_moves(state).map do |move|
        make(move, player, state)
        value_for_move = -nega_max_sym(opponent(player), state, false, table)
        unmake(move, state)
        [move, value_for_move]
      end.max_by { |move, value_for_move| value_for_move }
      top ? (return best.first) : save_values(table, state, best.last)
    end
  end
  table[state.join]
end

def save_values(table, state, value)
  table[state.join] = value # identity symmetry
  table[rotate90(state).join] = value
  table[rotate180(state).join] = value
  table[rotate270(state).join] = value
  table[reflect_main_diagonal(state).join] = value
  table[reflect_anti_diagonal(state).join] = value
  table[reflect_horizontal(state).join] = value
  table[reflect_vertical(state).join] = value
end

# rotation by 90 degrees
def rotate90(state)
  state.each_slice(LENGTH).reverse_each.to_a.transpose.flatten
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
def reflect_main_diagonal(state)
  state.each_slice(LENGTH).to_a.transpose.flatten
end

# reflection across the counter diagonal
def reflect_anti_diagonal(state)
  reflect_main_diagonal(rotate180(state))
end

# reflection across the horizontal
def reflect_horizontal(state)
  state.each_slice(LENGTH).reverse_each.to_a.flatten
end

# reflection across the vertical
def reflect_vertical(state)
  state.each_slice(LENGTH).flat_map(&:reverse)
end

# two approaches to taking symmetry into account:
# -- when storing a value in the transposition table, store the values for all symmetric states along with it (this is what we do above).
# -- when doing the lookup in our transposition table, check whether the values of symmetric states have already been computed (this is what we do below).

# "lookup approach"

def nega_max_sym_lookup(player, state, top = false, table = {})
  value = look_up_value(state, table)
  if value
    return value
  elsif terminal?(state)
    table[state.join] = payoff(player, state)
  else
    best = available_moves(state).map do |move|
      make(move, player, state)
      value_for_move = -nega_max_sym_lookup(opponent(player), state, false, table)
      unmake(move, state)
      [move, value_for_move]
    end.max_by { |move, value_for_move| value_for_move }
    top ? best.first : table[state.join] = best.last
  end
end

def look_up_value(state, table)
  table[state.join] ||
  table[rotate90(state).join] ||
  table[rotate180(state).join] ||
  table[rotate270(state).join] ||
  table[reflect_main_diagonal(state).join] ||
  table[reflect_anti_diagonal(state).join] ||
  table[reflect_horizontal(state).join] ||
  table[reflect_vertical(state).join]
end

## "Move generation approach"

def nega_max_choices(player, state, top = false, table = {})
  $calls += 1
  unless table[state.join]
    if terminal?(state)
      table[state.join] = payoff(player, state)
    else
      best = choices(state).map do |move|
        make(move, player, state)
        value_for_move = -nega_max_choices(opponent(player), state, false, table)
        unmake(move, state)
        [move, value_for_move]
      end.max_by { |move, value_for_move| value_for_move }
      top ? (return best.first) : save_values(table, state, best.last)
    end
  end
  table[state.join]
end

def choices(state)
  available_moves(state).inject([]) do |choices, move|
    if choices.any? { |other_move| equivalent?(move, other_move, state) }
      choices
    else
      choices + [move]
    end
  end
end

def equivalent?(move, other_move, state)
  state1 = try_move(move, state)
  state2 = try_move(other_move, state)
  symmetric?(state1, state2)
end

# this sucks:
def try_move(move, state)
  trial = state.dup
  trial[move] = true
  trial
end

def symmetric?(state1, state2)
  state1 == state2
  state1 == rotate90(state2) ||
  state1 == rotate180(state2) ||
  state1 == rotate270(state2) ||
  state1 == reflect_main_diagonal(state2) ||
  state1 == reflect_anti_diagonal(state2) ||
  state1 == reflect_horizontal(state2) ||
  state1 == reflect_vertical(state2)
end

$calls = 0
table = {}
puts Benchmark.realtime { nega_max_choices(P1, INITIAL_STATE, :top, table) }
# ^ 0.14 (so this is not particularly fast: it's about the speed of the transposition table approach)
p $calls
# ^ 2097
p table.size
# ^ 4738

display(*play(:nega_max_choices))
# X X O
# O O X
# X O X
# 0 --> 4 --> 1 --> 2 --> 6 --> 3 --> 5 --> 7 --> 8

## PRUNING

## -- do not calculate subtrees that are not good choices anyway

def alpha_beta(player, state, top = false, alpha = -10, beta = 10)
  if terminal?(state)
    payoff(player, state)
  else
    best = [nil, -10]
    available_moves(state).each do |move|
      make(move, player, state)
      value = [move, -alpha_beta(opponent(player), state, false, -beta, -alpha)]
      unmake(move, state)
      best = value if value.last > best.last
      alpha = [alpha, value.last].max
      break if alpha >= beta
    end
    top ? best.first : best.last
  end
end

# --------------------------------------------------------------------

# counting method calls

# analysis: COUNTING THE NUMBER OF CALLS TO NEGAMAX METHOD

# brute force negamax with step counter
def nega_max_value_steps(player, state)
  $calls += 1
  if terminal?(state)
    best_value = payoff(player, state)
  else
    best_value = available_moves(state).map do |move|
      state[move] = player
      value_for_move = -nega_max_value_steps(opponent(player), state)
      unmake(move, state)
      value_for_move
    end.max
  end
  best_value
end

# negamax with transposition table with step counter
def nega_max_trans_steps(player, state, top = false, table = {})
  $calls += 1
  unless table[state.join]
    if terminal?(state)
      table[state.join] = payoff(player, state)
    else
      best = available_moves(state).map do |move|
        make(move, player, state)
        value_for_move = -nega_max_trans_steps(opponent(player), state, false, table)
        unmake(move, state)
        [move, value_for_move]
      end.max_by { |move, value_for_move| value_for_move }
      top ? (return best.first) : table[state.join] = best.last
    end
  end
  table[state.join]
end

# negamax with transposition table, counting non-memoized calls
def nega_max_trans_steps_non_memoized(player, state, top = false, table = {})
  unless table[state.join]
    $calls += 1
    if terminal?(state)
      table[state.join] = payoff(player, state)
    else
      best = available_moves(state).map do |move|
        make(move, player, state)
        value_for_move = -nega_max_trans_steps_non_memoized(opponent(player), state, false, table)
        unmake(move, state)
        [move, value_for_move]
      end.max_by { |move, value_for_move| value_for_move }
      top ? (return best.first) : table[state.join] = best.last
    end
  end
  table[state.join]
end

# negamax with symmetry table and step counter
def nega_max_sym_steps(player, state, top = false, table = {})
  $calls += 1
  unless table[state.join]
    if terminal?(state)
      save_values(table, state, payoff(player, state))
    else
      best = available_moves(state).map do |move|
        make(move, player, state)
        value_for_move = -nega_max_sym_steps(opponent(player), state, false, table)
        unmake(move, state)
        [move, value_for_move]
      end.max_by { |move, value_for_move| value_for_move }
      top ? (return best.first) : save_values(table, state, best.last)
    end
  end
  table[state.join]
end

# symmetry lookup with step counter
def nega_max_sym_lookup_steps(player, state, top = false, table = {})
  $calls += 1
  value = look_up_value(state, table)
  if value
    return value
  elsif terminal?(state)
    table[state.join] = payoff(player, state)
  else
    best = available_moves(state).map do |move|
      make(move, player, state)
      value_for_move = -nega_max_sym_lookup_steps(opponent(player), state, false, table)
      unmake(move, state)
      [move, value_for_move]
    end.max_by { |move, value_for_move| value_for_move }
    top ? best.first : table[state.join] = best.last
  end
end

# alpha-beta pruning with step counter
def alpha_beta_steps(player, state, top = false, alpha = -10, beta = 10)
  $calls +=1
  if terminal?(state)
    payoff(player, state)
  else
    best = [nil, -10]
    available_moves(state).each do |move|
      make(move, player, state)
      value = [move, -alpha_beta_steps(opponent(player), state, false, -beta, -alpha)]
      unmake(move, state)
      best = value if value.last > best.last
      alpha = [alpha, value.last].max
      break if alpha >= beta
    end
    top ? best.first : best.last
  end
end

# --------------------------------------------------------------------

# Tests

# do the algorithms produce reasonable game-play?
# display(*play(:nega_max))
# display(*play(:nega_max_trans))
# display(*play(:nega_max_sym))
# display(*play(:nega_max_sym_lookup))
# display(*play(:alpha_beta))

# BENCHMARKS AND ANALYSIS

## time — 3x3 board

# player = 'X'
# state = INITIAL_STATE
# Benchmark.bmbm do |x|
#   x.report("bf     ") { select_move(:nega_max, player, state) }
#   x.report("trans  ") { select_move(:nega_max_trans, player, state) }
#   x.report("sym    ") { select_move(:nega_max_sym, player, state) }
#   x.report("lookup ") { select_move(:nega_max_sym_lookup, player, state) }
#   x.report("ab     ") { select_move(:alpha_beta, player, state) }
#   x.report("short  ") { select_move(:nega_max_shortcut, player, state) }
#   x.report("t-short") { select_move(:nega_max_trans_short, player, state) }
# end

=begin
             user     system      total        real
bf       5.680000   0.050000   5.730000 (  5.781872)
trans    0.100000   0.000000   0.100000 (  0.105050)
sym      0.050000   0.000000   0.050000 (  0.048830)
lookup   0.060000   0.000000   0.060000 (  0.058844)
ab       0.190000   0.000000   0.190000 (  0.193677)
short    0.610000   0.000000   0.610000 (  0.612566)
=end

# -----

## time — 4x4 board

# player = 'X'
# state = INITIAL_STATE
# Benchmark.bmbm do |x|
#   x.report("memo  ") { select_move(:nega_max_trans, player, state) }
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

# -----

# number of calls to the recursive method to produce first move

# brute force negamax:
# $calls = 0
# nega_max_value_steps(P1, INITIAL_STATE)
# p $calls # 549946 calls

# negamax with transposition table:
# $calls = 0
# nega_max_trans_steps(P1, INITIAL_STATE)
# p $calls # 16168 calls

# negamax with transposition: calls that are not answered with memoized value
# $calls = 0
# nega_max_trans_steps_non_memoized(P1, INITIAL_STATE)
# p $calls # 5478 (the number of distinct positions — these calls are necessary to produce the full lookup table)

# negamax with symmetry table:
# $calls = 0
# nega_max_sym_steps(P1, INITIAL_STATE)
# p $calls # 2271 calls

# alpha-beta pruning:
# $calls = 0
# alpha_beta_steps(P1, INITIAL_STATE)
# p $calls # 764

# negamax with symmetry lookup:
# $calls = 0
# nega_max_sym_lookup_steps(P1, INITIAL_STATE)
# p $calls # 2271

# -----

# size of the lookup table

# negamax with transposition table
# table = {}
# nega_max_trans(P1, INITIAL_STATE, true, table)
# p table.size # 5477

# negamax with symmetry table
# table = {}
# nega_max_sym(P1, INITIAL_STATE, true, table)
# p table.size # 5477

# negamax with complex lookup: how big is THAT table? (it's smaller)
# table = {}
# nega_max_sym_lookup(P1, INITIAL_STATE, true, table)
# p table.size # 764

# ---- Putting up a fight

# payoff method that favors long plays over short ones:

# def move_count(state)
#   SQUARES - available_moves(state).count
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
