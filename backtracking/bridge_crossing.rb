=begin

problem:

- N soldiers want to traverse a bridge from south to north.
- It is night, so the bridge can only be traversed with a torch. There is one torch.
- Up to two people can go together.
- The soldiers have different walking speeds. In fact, we are going to assume that the speeds to cross the bridge are pairwise different.
- Determine the minimum time needed to traverse the bridge, given walking times (in minutes) for all the soldiers.

=end

def initial_state(times)
  {
    soldiers: (0...times.size).to_a
    positions: (0...times.size).map { |index| :south  },
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

def moves(state)
  if state[:torch] == :north
    soldiers_at(:north, state).map { |soldier| [soldier] }
  else
    soldiers = soldiers_at(:south, state)
    soldiers.product(soldiers).select do |soldier1, soldier2|
      soldier1 != soldier2
    end
  end
end

def make(move, state)
  move.each do |soldier|
    flip(soldier, state)
    # add time for soldier
  end
end

def unmake(move, state)
  move.each do |soldier|
    flip(soldier, state)
    # subtract time for soldier
  end
end

def terminal?(state)
  state[:positions].all? { |position| position == :north }
end

def solve(state)
  # the backtracking algorithm
end

def start(times)
  solve(initial_state([1, 2, 5, 10]))
end
