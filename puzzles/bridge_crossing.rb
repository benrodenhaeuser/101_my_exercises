# A group of N soldiers has to cross a bridge at night, from south to north. A
# maximum of two people can cross the bridge at one time, and any party that
# crosses (either one or two people) must have a flashlight with them. There is
# only one flashlight. *The times taken by each person to cross the bridge are
# pairwise distinct.* If a pair of soldiers crosses the bridge together, the
# slower soldier's speed determines their joint pace. What is the minimal time
# to get everyone to the north?

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
    timer: 0
  }
end

def soldiers_at(location, state)
  state[:soldiers].select do |soldier|
    state[:positions][soldier] == location
  end
end

def moves(state, location)
  if location == :north
    soldiers_at(:north, state).map { |soldier| [soldier] }
  else
    soldiers_at(:south, state).combination(2).to_a
  end
end

def get_across(soldier, state, location)
  state[:positions][soldier] = opposite(location)
end

def get_back(soldier, state, location)
  state[:positions][soldier] = location
end

def opposite(location)
  location == :south ? :north : :south
end

def make_move(move, state, location)
  move.each do |soldier|
    get_across(soldier, state, location)
  end
  state[:timer] += move.map { |soldier| state[:speed][soldier] }.max
end

def unmake_move(move, state, location)
  move.each do |soldier|
    get_back(soldier, state, location)
  end
  state[:timer] -= move.map { |soldier| state[:speed][soldier] }.max
end

def terminal?(state)
  state[:positions].all? { |position| position == :north }
end

# ---------------------------------------------------------------------------
# backtracker
# ---------------------------------------------------------------------------

def time_to_cross(state, location = :south)
  p state
  if terminal?(state)
    state[:timer]
  else
    moves(state, location).map do |move|
      make_move(move, state, location)
      time = time_to_cross(state, opposite(location))
      unmake_move(move, state, location)
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
# unmake_move([0, 1], state)
# p state[:timer] # 0
# p state[:positions][0] # :south
# p state[:positions][1] # :south
# p state[:torch] # :south
# p terminal?(state) # false

# "classical" problem instance
p time_to_cross(initial_state([1, 2, 5, 10])) # 17
