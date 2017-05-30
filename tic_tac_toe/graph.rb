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

# --------------------------------------------------------------------

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

# p choices(INITIAL_STATE) # [0, 1, 4]

def build_graph(player, state, graph)
  unless terminal?(state)
    current_str = state.join
    graph[current_str] = {}
    choices(state).each do |choice|
      state[choice] = player
      next_str = state.join
      graph[current_str][choice] = next_str
      build_graph(opponent(player), state, graph)
      state[choice] = AVAILABLE
    end
  end
end

graph = {}

puts Benchmark.realtime {build_graph(P1, INITIAL_STATE, graph)} # 2 seconds
p graph.size # 2732 (??)

p graph[INITIAL_STATE.join]
p graph["X        "]

# {"         "=>{0=>"X        ", 1=>" X       ", 4=>"    X    "}}

# ... but we need recursion here!

## >> Yet another approach: Adapt Move Generation

# returns a value
def nega_max_choices(player, state, top = false, table = {})
  $calls += 1
  unless table[state.join]
    if terminal?(state)
      table[state.join] = payoff(player, state)
    else
      best = choices(available_moves(state), state).map do |move|
        make(move, player, state)
        value_for_move = -nega_max_choices(opponent(player), state, false, table)
        # p state
        unmake(move, state)
        [move, value_for_move]
      end.max_by { |move, value_for_move| value_for_move }
      top ? (return best.first) : table[state.join] = best.last
    end
  end
  table[state.join]
end

#
#
# $calls = 0
# table = {}
# puts Benchmark.realtime { nega_max_choices(P1, INITIAL_STATE, :top, table) }
# # ^ 0.38 (this is the fastest method I have seen. but does it actually work?)
# p $calls
# # ^ 8307 (now why is that? this is fewer calls than with a transposition table, but more than with a symmetry table.)
# p table.size
# # ^ 3480 (and why is that? this is *less* than the number of distinct positions), but more than the number of positions up to symmetry — which kind of makes sense)
#
# display(*play(:nega_max_choices))
# # X X O
# # O O X
# # X O X
# # 0 --> 4 --> 1 --> 2 --> 6 --> 3 --> 5 --> 7 --> 8
