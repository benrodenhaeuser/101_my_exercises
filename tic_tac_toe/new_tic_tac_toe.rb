# solving tic tac toe

require 'benchmark'

# MODELING THE GAME

EMPTY_SLOT = ' '
PLAYER1 = 'X'
PLAYER2 = 'O'
PLAYERS = [PLAYER1, PLAYER2]
INITIAL_STATE = (EMPTY_SLOT * 9).chars
WIN_LINES = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8],
  [0, 4, 8], [2, 4, 6]]

def terminal?(state)
  (PLAYERS.any? { |player| winner?(player, state) }) || full?(state)
end

def full?(state)
  state.none? { |value| value == EMPTY_SLOT }
end

def other(player)
  player == PLAYER1 ? PLAYER2 : PLAYER1
end

def winner?(player, state)
  WIN_LINES.any? { |line| line.all? { |index| state[index] == player } }
end

def payoff(player, state)
  winner?(player, state) ? 1 : (winner?(other(player), state) ? -1 : 0)
end

def empty_slots(state)
  (0..8).select { |index| state[index] == EMPTY_SLOT }
end

def choices(player, state)
  empty_slots(state).map do |index|
    choice = state.dup
    choice[index] = player
    choice
  end
end

def get_choice(player, state, method)
  send(method, player, state)[:choice]
end

def display(state)
  state.each_slice(3) { |slice| puts slice.join(' ').center(10) }
  puts "> payoff: #{payoff(PLAYER1, state)}\n\n" if terminal?(state)
end

def play(state: INITIAL_STATE, player: PLAYER1, method: best_choice_memo)
  loop do
    break if terminal?(state)
    state = get_choice(player, state, method)
    player = other(player)
  end
  state
end

# SOLVING THE GAME

# brute force negamax

def nega_max(player, state)
  if terminal?(state)
    payoff(player, state)
  else
    choices(player, state).map do |choice|
      -nega_max(other(player), choice)
    end.max
  end
end

# brute force best_choice

# note: returns pair (value, choice)

def best_choice(player, state)
  if terminal?(state)
    { value: payoff(player, state), choice: nil }
  else
    values = choices(player, state).map do |choice|
      { value: -(best_choice(other(player), choice))[:value], choice: choice }
    end.max_by { |pair| pair[:value] }
  end
end

# puts Benchmark.realtime { best_choice }
# 6.19 seconds

# negamax with memoization

def nega_max_memo(player, state, table = {})
  return table[state] if table[state]

  if terminal?(state)
    table[state] = payoff(player, state)
  else
    values = choices(player, state).map do |choice|
      -nega_max_memo(other(player), choice, memo)
    end
    table[state] = values.max
  end
end

# puts Benchmark.realtime { nega_max_memo }
# 0.19 seconds

# best choice with memoization

def best_choice_memo(player, state, table = {})
  return table[state] if table[state]

  if terminal?(state)
    table[state] = { value: payoff(player, state), choice: nil }
  else
    pairs = choices(player, state).map do |choice|
      {
        value: -best_choice_memo(other(player), choice, table)[:value],
        choice: choice
      }
    end
    table[state] = pairs.max_by { |pair| pair[:value] }
  end
end

# >> adjust play_a_game so that it uses best_choice_memo
# puts Benchmark.realtime { display(play) }
# 0.27 seconds

# negamax with memoization and reflection

def reflect(state)
  state.dup.map do |value|
    case value
    when PLAYER1 then PLAYER2
    when PLAYER2 then PLAYER1
    else
      EMPTY_SLOT
    end
  end
end

def nega_max_trans_refl(player, state, table = {})
  if table[state]
    return table[state]
  elsif table[reflect(state)]
    return -table[reflect(state)]
  end

  if terminal?(state)
    table[state] = payoff(player, state)
  else
    values = choices(player, state).map do |choice|
      -nega_max_trans_refl(other(player), choice, memo)
    end
    table[state] = values.max
  end
end

# puts Benchmark.realtime { nega_max_trans_refl }
# 0.11 seconds

# negamax with alpha-beta pruning

def alpha_beta(player, state, alpha = -10, beta = 10)
  if terminal?(state)
    payoff(player, state)
  else
    best = -10
    choices(player, state).each do |choice|
      value = -alpha_beta(other(player), choice, -beta, -alpha)
      best = [best, value].max
      alpha = [alpha, value].max
      break if alpha >= beta
    end
    best
  end
end

# puts Benchmark.realtime { alpha_beta }
# 0.19 seconds

puts "time elapsed: #{Benchmark.realtime { display(play(method: :best_choice_memo)) }} seconds"
# 6.4 seconds
