# given a directed acyclic graph, sort the list of vertices in such a way that for any edge (u, v) in the graph, u appears before v in the sorted list.

# -----------------------------------------------------------------------------
# solution using depth-first search
# -----------------------------------------------------------------------------

# levitin, p. 139: the order in which vertices are popped off of the stack
# traces the required sorting order: elements that are popped off of the stack earlier are "to the right" of all elements popped off of the stack later.

# so recording the popped off elements in a list provides a solution for
# topological sorting (if we push all popped off elements to the list, we just have to reverse it in the end).

# -----------------------------------------------------------------------------
# implementation
# -----------------------------------------------------------------------------

# (see depth_first_search.rb for the dfs algorithm I am using here.)

def topo_sort(graph)
  discovered = {}
  list = []
  stack = []

  graph.keys.each do |vtx|
    next if discovered[vtx]

    stack << [vtx, 0]
    discovered[vtx] = true

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
        list << stack.pop.first
      end

    end
  end

  list.reverse
end


graph = {
  :c1 => [:c3],
  :c2 => [:c3],
  :c3 => [:c4, :c5],
  :c4 => [:c5],
  :c5 => []
}

p topo_sort(graph) == [:c2, :c1, :c3, :c4, :c5]

# the evolution of the stack during the execution:
# [[:c1, 0]]
# [[:c1, 1], [:c3, 0]]
# [[:c1, 1], [:c3, 1], [:c4, 0]]
# [[:c1, 1], [:c3, 1], [:c4, 1], [:c5, 0]]
# [[:c1, 1], [:c3, 1], [:c4, 1]]
# [[:c1, 1], [:c3, 1]]
# [[:c1, 1], [:c3, 2]]
# [[:c1, 1]]
# [[:c2, 0]]
# [[:c2, 1]]
