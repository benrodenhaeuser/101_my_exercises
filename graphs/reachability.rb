# given a directed graph, and a vertex s, compute the vertices reachable from s
# in the sense of the transitive closure.

# -----------------------------------------------------------------------------
# comments
# -----------------------------------------------------------------------------

=begin

- adapt from depth first search.
- notion of reachability: vertex v is reachable from s in graph G if we can get
  from s to v in n >= 1 steps by following the G-edges.
- so it is *not* the case that s itself is trivially reachable from s!
  i.e., we only want to count the source node as reachable from the
  source if there is a sequence of edges connecting source to source.
- this notion of reachability gives rise to the transitive closure of a graph.
- there is another notion of reachability, which does count a vertex as
  trivially reachable from itself (by following 0 edges). this notion of
  reachability gives rise to the reflexive transitive closure.

=end

# -----------------------------------------------------------------------------
# reachability via depth-first search
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

# -----------------------------------------------------------------------------
# transitive closure
# -----------------------------------------------------------------------------

# we can produce the transitive closure of  a graph using the reachability
# method from above. this is inefficient, however, since we are traversing the
# graph multiple times.

def transitive_closure(graph)
  graph_plus = {}
  graph.each_key do |vtx|
    graph_plus[vtx] = reachable(graph, vtx)
  end
  graph_plus
end

# in this graph, every node is reachable from every other node:

graph = {
  'a' => ['b'],
  'b' => ['c'],
  'c' => ['a'],
}

p transitive_closure(graph)
# {"a"=>["b", "c", "a"], "b"=>["c", "a", "b"], "c"=>["a", "b", "c"]}
