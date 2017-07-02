# given a directed graph, and a vertex s, compute the vertices reachable from s.

# notion of reachability: vertex v is reachable from s if we can get from s to
# v in n >= 1 steps by following the edges.
# so it is not the case that s itself is trivially reachable from s!

# -----------------------------------------------------------------------------
# algorithm
# -----------------------------------------------------------------------------

=begin

- adapt from depth first search.

=end

# -----------------------------------------------------------------------------
# solution
# -----------------------------------------------------------------------------

def reachable(graph, source)
  reached = {}
  stack = []

  graph[source].each do |vtx|
    stack = [vtx] unless reached[vtx]

    while !stack.empty?
      reached_vtx = stack.pop
      reached[reached_vtx] = true
      graph[reached_vtx].each do |neighbor|
        stack.push(neighbor) unless reached[neighbor]
      end
    end
  end

  reached.keys
end

# in this graph, 'a' is reachable from 'a':

graph = {
  'a' => ['b'],
  'b' => ['c'],
  'c' => ['a'],
}

p reachable(graph, 'a') # => ["b", "c", "a"]

# in this graph, 'a' is not reachable from 'a':

graph = {
  'a' => ['b'],
  'b' => ['c'],
  'c' => [],
}

p reachable(graph, 'a') # => ["b", "c"]
