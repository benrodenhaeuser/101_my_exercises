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
    positions: (0...times.size).map { |index| :south  }, # where are the soldiers?
    speed: times, # how much time does each soldier need?
    clock: 0, # time spent crossing so far
    torch: :south, # is torch south or north?
    number_of_soldiers: times.size # number of soldiers
  }
end

# a move: one-element or two-element array (elements are soldiers, i.e., indices)

def moves(state)
  if state[:torch] == :south
    (0...state[:number_of_soldiers]).select do |soldier|
      state[positions][soldier] == :south
    end
    choices.map { | }
  else
    # pick one index from the soldier array.
  end
end

def make_move(state, soldiers, times)
  # flip the position of a number of soldiers (north to south or vice versa)
  # update the time
end

def unmake(move)
  # flip the position of
end

def terminal?(state)
  # everyone is north of the bridge
end
