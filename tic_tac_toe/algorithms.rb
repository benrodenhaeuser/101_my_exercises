# algorithms to solve tic tac toe:
# - brute force negamax value
# - brute force negamax with move
# - negamax with transposition table
# - negamax with symmetry table
# - negamax with alpha beta pruning

# brute force negamax
def value(player, state)
  if terminal?(state)
    best_value = payoff(player, state)
  else
    best_value = available_moves(state).map do |move|
      state[move] = player
      value_for_move = -value(opponent(player), state)
      state[move] = AVAILABLE
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
      state[move] = player
      value_for_move = -(nega_max(opponent(player), state))
      state[move] = AVAILABLE
      [move, value_for_move]
    end.max_by { |move, value_for_move| value_for_move }
    top ? (return best.first) : best_value = best.last
  end
  best_value
end

# negamax with memoization: transposition table
def nega_max_trans(player, state, top = false, table = {})
  unless table[state.join]
    if terminal?(state)
      save_value(table, state, payoff(player, state))
    else
      best = available_moves(state).map do |move|
        state[move] = player
        value_for_move = -nega_max_trans(opponent(player), state, false, table)
        state[move] = AVAILABLE
        [move, value_for_move]
      end.max_by { |move, value_for_move| value_for_move }
      top ? (return best.first) : save_value(table, state, best.last)
    end
  end
  table[state.join]
end

def save_value(table, state, value)
  table[state.join] = value
end

# negamax with memoization: symmetry table
def nega_max_sym(player, state, top = false, table = {})
  unless table[state.join]
    if terminal?(state)
      save_sym(table, state, payoff(player, state))
    else
      best = available_moves(state).map do |move|
        state[move] = player
        value_for_move = -nega_max_sym(opponent(player), state, false, table)
        state[move] = AVAILABLE
        [move, value_for_move]
      end.max_by { |move, value_for_move| value_for_move }
      top ? (return best.first) : save_sym(table, state, best.last)
    end
  end
  table[state.join]
end

def save_sym(table, state, value)
  table[state.join] = value
  table[rotate90(state).join] = value
  table[rotate180(state).join] = value
  table[rotate270(state).join] = value
  table[transpose(state).join] = value
  table[reflect_sec_diag(state).join] = value # reverse_transpose?
  table[reflect_horizontal(state).join] = value
  table[reflect_vertical(state).join] = value
end

# TODO: check the naming for alpha-beta

# negamax with alpha-beta pruning
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
