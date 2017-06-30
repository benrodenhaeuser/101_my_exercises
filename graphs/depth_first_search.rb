# depth-first search of a graph

# -----------------------------------------------------------------------------
# output: list of discovered vertices ("DFS ordering")
# -----------------------------------------------------------------------------

def depth_first_d(graph, vtx, discovered = {})
  discovered[vtx] = true
  graph[vtx].each do |other_vtx|
    depth_first_d(graph, other_vtx, discovered) unless discovered[other_vtx]
  end
  discovered.keys
end

# -----------------------------------------------------------------------------
# output: list of vertices in the order in which they were visited
# -----------------------------------------------------------------------------

def depth_first_v(graph, vtx, visited = [])
  visited << vtx
  graph[vtx].each do |other_vtx|
    depth_first_v(graph, other_vtx, visited) unless visited.include?(other_vtx)
    visited << vtx unless visited.last == vtx
  end
  visited
end

# -----------------------------------------------------------------------------
# iterative depth first search
# -----------------------------------------------------------------------------

# idea:
# - use a stack to control the algorithm.
# - the top of the stack represents the vertex we are currently visiting.
# an element is popped from the stack if all its successors have been
# discovered (it has become a "dead end").

def depth_first_stack(graph, vtx)
  stack = [vtx]
  discovered = { vtx => true }

  while stack != []

    # how to improve the next line?
    next_vtx = graph[stack.last].find { |some_vtx| !discovered[some_vtx]}
    if next_vtx
      discovered[next_vtx] = true
      stack.push(next_vtx)
    else
      stack.pop
    end
  end

  discovered.keys
end

# the problem with the above implementation is the step where we search the
# adjacency list for the next undiscovered vertex.

# -----------------------------------------------------------------------------
# another implementation of iterative depth first search
# -----------------------------------------------------------------------------

# found here: http://www.cs.toronto.edu/~heap/270F02/node36.html
# here, the idea is to pop an element once discovered, and push all its
# neighbors that have not yet been discovered.

# this results in a "reversed" order of visits.


def depth_first_stack_2(graph, start_vtx)
  stack = [start_vtx]
  discovered = {}

  while stack != []

    current = stack.pop
    discovered[current] = true
    graph[current].each do |vtx|
      stack.push(vtx) unless discovered[vtx]
    end

  end

  discovered.keys

end

# -----------------------------------------------------------------------------
# tests
# -----------------------------------------------------------------------------

graph =
{
  0 => [1, 2],
  1 => [2],
  2 => [3],
  3 => [0]
}

p depth_first_d(graph, 0) == [0, 1, 2, 3]
p depth_first_v(graph, 0) == [0, 1, 2, 3, 2, 1, 0]
p depth_first_stack(graph, 0) == [0, 1, 2, 3]
p depth_first_stack_2(graph, 0) == [0, 2, 3, 1]
