# depth-first search of a graph

# in the following, we are making the assumption that the graph is
# "point-generated". for the general case, we need a wrapper method that
# explores all possible source vertices for exploring the graph.

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
# iterative depth first search: textbook version
# -----------------------------------------------------------------------------

# found here: http://www.cs.toronto.edu/~heap/270F02/node36.html
# the idea is to pop a vertex once discovered, and push all its
# neighbors on the stack that have not yet been discovered.

def depth_first_stack(graph, start_vtx)
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
# iterative depth first search: another version
# -----------------------------------------------------------------------------

# the idea of this implementation is to mimick the way the call stack works:
# - the top of the stack represents the vertex we are currently visiting.
# - an element is popped from the stack if all its successors have been
#   discovered (it has become a "dead end").
# - to make this work, we record, on the stack, which neighbor of a vertex is
#   to be investigated next

def depth_first_stack_2(graph, vtx)
  stack = [[vtx, 0]]
  discovered = { vtx => true }

  while stack != []
    # p stack

    top_vtx = stack[-1][0]
    pos = stack[-1][1]
    next_vtx = graph[top_vtx][pos]

    if next_vtx
      stack[-1][1] += 1
      stack.push([next_vtx, 0]) unless discovered[next_vtx]
      discovered[next_vtx] = true
    else
      stack.pop
    end

  end

  discovered.keys
end

# -----------------------------------------------------------------------------
# tests
# -----------------------------------------------------------------------------

graph =
{
  'a' => ['b', 'c'],
  'b' => ['c'],
  'c' => ['d'],
  'd' => ['a']
}

# p depth_first_d(graph, 'a') == ['a', 'b', 'c', 'd']
# p depth_first_v(graph, 'a') == ['a', 'b', 'c', 'd', 'c', 'b', 'a']
# p depth_first_stack(graph, 'a') == ['a', 'c', 'd', 'b']
p depth_first_stack_2(graph, 'a') == ["a", "b", "c", "d"]

# this is what the stack looks like at the beginning of each
# iteration of the while loop:

# [["a", 0]]
# [["a", 1], ["b", 0]]
# [["a", 1], ["b", 1], ["c", 0]]
# [["a", 1], ["b", 1], ["c", 1], ["d", 0]]
# [["a", 1], ["b", 1], ["c", 1], ["d", 1]]
# [["a", 1], ["b", 1], ["c", 1]]
# [["a", 1], ["b", 1]]
# [["a", 1]]
# [["a", 2]]
