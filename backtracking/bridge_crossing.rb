=begin

problem:

- N soldiers want to traverse a bridge from south to north.
- It is night, so the bridge can only be traversed with a torch. There is one torch.
- Up to two people can go together.
- The soldiers have different walking speeds. In fact, we are going to assume that the speeds to cross the bridge are pairwise different.
- Determine the minimum time needed to traverse the bridge, given walking times (in minutes) for all the soldiers.

modeling:

- input: an array `soldiers` (representing the number of soldiers (array size) and the traversal time for each soldier, i.e., `soldier[0]` is the traversal time for the first soldier, `soldier[1]` is the traversal time for the second soldier, and so on).
- output: an integer (representing the minimal number of minutes needed to get everyone to the north of the bridge).

observations:

- we can solve this with depth-first search/backtracking.

- what do we need?
  - game position:
    - current position of the soldiers
    - (current position of the torch)
    - time passed
  - available moves in a game position (be careful to exclude infinite runs!)
  - make/unmake function (i.e., making/unmaking a move)
  - characterization of terminal position (i.e., everyone is in the south)

  - a recursive function that computes the minimal time needed to reach
    terminal position by searching the game tree.

- what about *infinite runs*?
  - it's very easy to produce infinite runs, for example, we could have one
    particular soldier going back and forth with the torch alone ad infinitum
  - policy:
    - if the torch is south, two soldiers cross
    - if the torch is north, one soldier crosses
  - "obviously" we cannot save time doing it differently.

=end

def initial_state(times)
  {
    soldiers: (0...times.size)
    positions: (0...times.size).map { |index| :south  },
    speed: times,
    timer: 0,
    torch: :south
  }
end

# a move: one-element or two-element array (elements are soldiers, i.e., indices)

def moves(state)
  if state[:torch] == :north
    state[:soldiers].select do |soldier|
      state[:positions][soldier] == :north
    end.map { |soldier| [soldier] }
  else
    # any two soldiers in the south (as two-elem array)
  end
end

def move_soldiers(state, soldiers)
  # flip the position of every soldier in array soldiers
  # add time accordingly
end

def unmove_soldiers(move, soldiers)
  # flip the position of every soldier in array soldiers
  # subtract time accordingly
end

def terminal?(state)
  state[:positions].all? { |position| position == :north }
end

def solve(times)
  state = initial_state(times)
  # TODO: the backtracking algorithm
end
