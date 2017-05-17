# tic tac toe

PLAYERS = ['X', 'O']
INITIAL = ('-' * 9).chars
WIN_LINES = [
  [0, 1, 2], [3, 4, 5], [6, 7, 8],
  [0, 3, 6], [1, 4, 7], [2, 5, 8],
  [0, 4, 8], [2, 4, 6]
]

def terminal?(state)
  (PLAYERS.any? { |player| winner?(player, state) }) || full?(state)
end

def full?(state)
  state.none? { |value| value == '-' }
end

def opponent(player)
  player == 'X' ? 'O' : 'X'
end

def winner?(player, state)
  WIN_LINES.any? { |line| line.all? { |index| state[index] == player } }
end

def payoff(player, state)
  winner?(player, state) ? 1 : (winner?(opponent(player), state) ? -1 : 0)
end

def actions(player, state)
  actions = []
  (0..8).select { |index| state[index] == '-' }.each do |index|
    state[index] = player
    actions << state.dup
    state[index] = '-'
  end
  actions
end

def get_choice(player, state)
  actions(player, state).sample
end

def get_game(state = INITIAL)
  player = 'X'
  loop do
    break if terminal?(state)
    state = get_choice(player, state)
    player = opponent(player)
  end
  state
end

def display(state)
  state.each_slice(3) { |slice| puts slice.join(' ').center(10) }
  puts "> payoff: #{payoff('X', state)}\n\n"
end

# testing things
# 10.times do
#   display(get_game())
# end
