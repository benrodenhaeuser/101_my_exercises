# Crossing the bridge at night

# A group of N soldiers has to cross a bridge at night, from south to north. A
# maximum of two people can cross the bridge at one time, and any party that
# crosses (either one or two people) must have a flashlight with them. There is
# only one flashlight. If a pair of soldiers crosses the bridge together, the
# slower soldier's speed determines their joint pace. What is the minimal time
# to get everyone to the north?

# The times taken by the soldiers to cross the bridge are pairwise distinct.
# This is not a crucial assumption, but simplifies the modeling somewhat.

# (Levitin, Puzzle Book)

def initial_state(soldiers)
  {
    soldiers: soldiers,
    positions: initial_positions(soldiers),
    clock: 0
  }
end

def initial_positions(soldiers)
  soldiers.map { |soldier| [soldier, :south] }.to_h
end

def soldiers_at(location, state)
  state[:soldiers].select do |soldier|
    state[:positions][soldier] == location
  end
end

# we rely on the fact that the optimal solution will be a succession of two guys going north, followed by one guy going south, and so on.
def parties(location, state)
  if location == :north
    soldiers_at(:north, state).map { |soldier| [soldier] } # one guy
  else
    soldiers_at(:south, state).combination(2).to_a # two guys
  end
end

def opposite(location)
  location == :south ? :north : :south
end

def get_to(location, soldier, state)
  state[:positions][soldier] = location
end

def transfer(party, state, location)
  party.each do |soldier|
    get_to(opposite(location), soldier, state)
  end
  state[:clock] += party.max
end

def untransfer(party, state, location)
  party.each do |soldier|
    get_to(location, soldier, state)
  end
  state[:clock] -= party.max
end

def terminal?(state)
  state[:positions].values.all? { |position| position == :north }
end

def minimal_crossing_time(state, location = :south)
  if terminal?(state)
    state[:clock]
  else
    parties(location, state).map do |party|
      transfer(party, state, location)
      time = minimal_crossing_time(state, opposite(location))
      untransfer(party, state, location)
      time
    end.min
  end
end

# tests:
p minimal_crossing_time(initial_state([5, 10, 20, 25])) # 60
p minimal_crossing_time(initial_state([1, 2, 5, 10])) # 17
p minimal_crossing_time(initial_state([2, 3, 5, 8])) # 19
p minimal_crossing_time(initial_state([1, 3, 6, 8, 12])) # 29
p minimal_crossing_time(initial_state([1, 3, 4, 6, 8, 9])) # 31

# (https://www.math.uni-bielefeld.de/~sillke/PUZZLES/crossing-bridge)
