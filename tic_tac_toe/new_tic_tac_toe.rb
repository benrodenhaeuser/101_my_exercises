# tic tac toe

require 'benchmark'

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

def empty_slots(state)
  (0..8).select { |index| state[index] == '-' }
end

def choices(player, state)
  empty_slots(state).map do |index|
    choice = state.dup
    choice[index] = player
    choice
  end
end

def get_choice(player, state)
  choices(player, state).sample # here, we would like to include negamax choices
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

def mirror(state)
  state.dup.map do |value|
    case value
    when 'X' then 'O'
    when 'O' then 'X'
    else
      '-'
    end
  end
end

# testing things

# def display(state)
#   state.each_slice(3) { |slice| puts slice.join(' ').center(10) }
#   puts "> payoff: #{payoff('X', state)}\n\n"
# end
#
# 10.times do
#   display(get_game())
# end

# brute force negamax

def get_value(player = 'X', state = INITIAL)
  if terminal?(state)
    payoff(player, state)
  else
    choices(player, state).map do |choice|
      -get_value(opponent(player), choice)
    end.max
  end
end

# puts Benchmark.realtime { get_value }
# 6.14 seconds

# negamax with memoization

def get_value(player = 'X', state = INITIAL, memo = {})
  return memo[state] if memo[state]

  if terminal?(state)
    memo[state] = payoff(player, state)
  else
    values = choices(player, state).map do |choice|
      -get_value(opponent(player), choice, memo)
    end
    memo[state] = values.max
  end
end

# puts Benchmark.realtime { get_value }
# # 0.19 seconds

# negamax with memoization and symmetries

def get_value(player = 'X', state = INITIAL, memo = {})
  if memo[state]
    return memo[state]
  elsif memo[mirror(state)]
    return -memo[mirror(state)]
  end

  if terminal?(state)
    memo[state] = payoff(player, state)
  else
    values = choices(player, state).map do |choice|
      -get_value(opponent(player), choice, memo)
    end
    memo[state] = values.max
  end
end

# puts Benchmark.realtime { get_value }
# # 0.11 seconds
