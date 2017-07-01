# given a directed acyclic graph, sort the list of vertices in such a way that for any edge (u, v) in the graph, u appears before v in the sorted list.

# -----------------------------------------------------------------------------
# solution using depth-first search
# -----------------------------------------------------------------------------

=begin

the order in which vertices are popped off of the stack
traces the required sorting order: elements that are popped off of the stack
earlier are "to the right" of all elements popped off of the stack later.

so recording the popped off elements in a list provides a solution for
topological sorting (if we push all popped off elements to the list, we just
have to reverse it in the end).

(levitin, algorithms book, p. 139)
(CLRS also describe this algorithm)

=end

# -----------------------------------------------------------------------------
# implementation with depth-first search
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




# -----------------------------------------------------------------------------
# solution using in-degrees
# -----------------------------------------------------------------------------

=begin

another solution is by using the in-degrees of vertices in the graph.
the in-degree of a vertex v is the number of edges (u, u') such that u' = v.

to build a topologically sorted list for a given graph, the first element of the list has to be a vertex with in-degree 0. the idea is to pick some such vertex, push it to the list, mark the vertex as "picked", and decrement the in-degree of the vertices accessible from the vertex. repeating this process, we will eventually pick all vertices, in the right order.

(cormen, algorithms unlocked, p. 77)

=end

# -----------------------------------------------------------------------------
# description of algorithm with in-degrees
# -----------------------------------------------------------------------------

=begin

- given a directed acyclic graph G with edges [e_1, ..., e_n].
- make a hash whose keys are the edges, such that the value for each key k is
  the in-degree of k.
- initialize an empty list
- while there is a key in the hash whose in-degree is >= 0

  - pick a key v whose in-degree is 0,
    - set hash[v] = -1 (to ensure termination of the while loop)
    - append v to the list,
  - decrement in the hash the in-degree of any vertex u such that (u, v) is an
    edge in the graph.
- return the list.

=end

# -----------------------------------------------------------------------------
# implementation with in-degrees
# -----------------------------------------------------------------------------

def get_in_degrees(graph)
  in_degrees = {}
  graph.keys.each { |vtx| in_degrees[vtx] = 0 }
  graph.values.each do |neighbors|
    neighbors.each do |neighbor|
      in_degrees[neighbor] += 1
    end
  end
  in_degrees
end

def topo_sort_in_degrees(graph)
  in_degrees = get_in_degrees(graph)
  next_vertices = graph.keys.select { |vtx| in_degrees[vtx] == 0 }
  list = []

  while vtx = next_vertices.pop
    list << vtx
    in_degrees[vtx] = -1
    graph[vtx].each do |neighbor|
      in_degrees[neighbor] -= 1
      next_vertices.push(neighbor) if in_degrees[neighbor] == 0
    end
  end

  list
end


# -----------------------------------------------------------------------------
# tests
# -----------------------------------------------------------------------------

graph = {
  :c1 => [:c3],
  :c2 => [:c3],
  :c3 => [:c4, :c5],
  :c4 => [:c5],
  :c5 => []
}

# test with depth-first search:
p topo_sort(graph) == [:c2, :c1, :c3, :c4, :c5]

# the evolution of the stack during the execution:
# [[:c1, 0]]
# [[:c1, 1], [:c3, 0]]
# [[:c1, 1], [:c3, 1], [:c4, 0]]
# [[:c1, 1], [:c3, 1], [:c4, 1], [:c5, 0]]
# [[:c1, 1], [:c3, 1], [:c4, 1]]
# [[:c1, 1], [:c3, 1]]
# [[:c1, 1], [:c3, 2]]
# [[:c1, 1]] # finally done with :c1 now
# [[:c2, 0]] # the trace for :c2 is short: everything else has been visited!
# [[:c2, 1]]

p topo_sort_in_degrees(graph) == [:c2, :c1, :c3, :c4, :c5]
