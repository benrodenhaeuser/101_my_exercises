# given a directed acyclic graph, sort the list of vertices in such a way that for any edge (u, v) in the graph, u appears before v in the sorted list.

# -----------------------------------------------------------------------------
# solution using depth-first search
# -----------------------------------------------------------------------------

=begin

the order in which vertices are popped off of the stack in depth first search
tracks the required sorting order in reverse: elements that are popped off of
the stack earlier are "to the right" of all elements popped off of the stack
later.

(levitin, algorithms book, p. 139)
(CLRS also describe this algorithm)

=end

# -----------------------------------------------------------------------------
# implementation with iterative depth-first search
# -----------------------------------------------------------------------------

# (see depth_first_search.rb for the dfs algorithm used here.)

def topo_sort_it(graph)
  discovered = {}
  sorted_list = []
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
        sorted_list << stack.pop.first
      end

    end
  end

  sorted_list.reverse
end

# -----------------------------------------------------------------------------
# implementation with recursive depth-first search
# -----------------------------------------------------------------------------

# note that we have two places where we push to the sorted list, which seems
# odd on one hand. on the other hand, it's maybe not so odd, because these are
# the two places where a method returns, i.e., a vertex is popped off the call
# stack.

def topo_sort_rec_wrap(graph, discovered = {}, sorted_list = [])
  graph.keys.each do |vtx|
    next if discovered[vtx]
    topo_sort_rec(graph, vtx, discovered, sorted_list)
    sorted_list << vtx
  end
  sorted_list.reverse
end

def topo_sort_rec(graph, vtx, discovered = {}, sorted_list)
  discovered[vtx] = true
  graph[vtx].each do |neighbor|
    unless discovered[neighbor]
      topo_sort_rec(graph, neighbor, discovered, sorted_list)
      sorted_list << neighbor
    end
  end
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
  zero_vertices = graph.keys.select { |vtx| in_degrees[vtx] == 0 }
  sorted_list = []

  while vtx = zero_vertices.pop
    sorted_list << vtx
    in_degrees[vtx] = -1
    graph[vtx].each do |neighbor|
      in_degrees[neighbor] -= 1
      zero_vertices.push(neighbor) if in_degrees[neighbor] == 0
    end
  end

  sorted_list
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

# test with iterative depth-first search:
p topo_sort_it(graph) == [:c2, :c1, :c3, :c4, :c5]

# test with recursive depth-first search:
p topo_sort_rec_wrap(graph) == [:c2, :c1, :c3, :c4, :c5]

# test with in-degrees implementation:
p topo_sort_in_degrees(graph) == [:c2, :c1, :c3, :c4, :c5]
