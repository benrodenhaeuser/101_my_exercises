# A group of N soldiers has to cross a bridge at night, from south to north. A maximum of two people can cross the bridge at one time, and any party that crosses (either one or two people) must have a flashlight with them. There is only one flashlight. *The times taken by each person to cross the bridge are pairwise distinct.* If a pair of soldiers crosses the bridge together, the slower soldier's speed determines their joint pace. What is the minimal time to get everyone to the north?

# Wikipedia: https://en.wikipedia.org/wiki/Bridge_and_torch_problem
# A paper on the topic: https://www.researchgate.net/publication/220530399_Crossing_the_Bridge_at_Night
# Material on the puzzle: https://www.math.uni-bielefeld.de/~sillke/PUZZLES/crossing-bridge

# ---------------------------------------------------------------------------
# modeling the puzzle
# ---------------------------------------------------------------------------

def soldiers(times)
  (0...times.size).to_a
end

def initial_positions(times)
  (0...times.size).map { :south  }
end

def initial_state(times)
  {
    soldiers: soldiers(times),
    positions: initial_positions(times),
    speed: times,
    timer: 0,
    torch: :south
  }
end

def soldiers_at(location, state)
  state[:soldiers].select do |soldier|
    state[:positions][soldier] == location
  end
end

def combinations(array, k = 2)
  if k == 0
    [[]]
  elsif k == 1
    array.map { |elem| [elem] }
  elsif array.size >= k
    combinations(array[1..-1], k - 1).map { |combo| [array[0]] + combo } +
    combinations(array[1..-1], k)
  else
    []
  end
end

def moves(state)
  if state[:torch] == :north
    soldiers_at(:north, state).map { |soldier| [soldier] }
  else
    combinations(soldiers_at(:south, state))
  end
end

def move_across(soldier, state)
  if state[:positions][soldier] == :south
    state[:positions][soldier] = :north
  else
    state[:positions][soldier] = :south
  end
end

def carry_the_torch_across(state)
  if state[:torch] == :south
    state[:torch] = :north
  else
    state[:torch] = :south
  end
end

def make_move(move, state)
  move.each do |soldier|
    move_across(soldier, state)
  end
  carry_the_torch_across(state)
  state[:timer] += move.map { |soldier| state[:speed][soldier] }.max
end

def unmake_move(move, state)
  move.each do |soldier|
    move_across(soldier, state)
  end
  carry_the_torch_across(state)
  state[:timer] -= move.map { |soldier| state[:speed][soldier] }.max
end

def terminal?(state)
  state[:positions].all? { |position| position == :north }
end

# ---------------------------------------------------------------------------
# backtracker
# ---------------------------------------------------------------------------

def time_to_cross(state)
  if terminal?(state)
    # p state
    state[:timer]
  else
    moves(state).map do |move|
      make_move(move, state)
      # p state
      time = time_to_cross(state)
      unmake_move(move, state)
      time
    end.min
  end
end

# ---------------------------------------------------------------------------
# tests
# ---------------------------------------------------------------------------

# basic machinery

# state = initial_state([1, 2, 5, 10])
# p soldiers_at(:north, state) # []
# p soldiers_at(:south, state) # [0, 1, 2, 3]
# p moves(state) # [[0, 1], [0, 2], [0, 3], [1, 2], [1, 3], [2, 3]]
# make_move([0, 1], state)
# p state[:timer] # 3
# p state[:positions][0] # :north
# p state[:positions][1] # :north
# p state[:torch] # :north
# unmake_move([0, 1], state)
# p state[:timer] # 0
# p state[:positions][0] # :south
# p state[:positions][1] # :south
# p state[:torch] # :south
# p terminal?(state) # false

# "classical" problem instance
p time_to_cross(initial_state([1, 2, 5, 10])) # 17
