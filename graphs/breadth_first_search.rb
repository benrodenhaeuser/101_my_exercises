# problem: traverse a (point-generated) graph in the breadth-first manner.

# -----------------------------------------------------------------------------
# outline of algorithm
# -----------------------------------------------------------------------------

=begin

  given a graph and a vertex

  enqueue the vertex
  make the vertex black
  initialize an empty output list

  while the queue is not empty:
    dequeue next_vertex
    push next_vtx to the output list
    for every neighbor of next_vtx:
      enqueue the neighbour unless it is black
      make the neighbor black

  return the output list

=end

# -----------------------------------------------------------------------------
# implementation
# -----------------------------------------------------------------------------

require 'thread'

def breadth_first(graph, vertex)
  queue = Queue.new
  queue.enq(vertex)
  acknowledged = { vertex => true }
  discovered = {}

  while !queue.empty?
    next_vtx = queue.deq
    discovered[next_vtx] = true
    graph[next_vtx].each do |neighbor|
      queue.enq(neighbor) unless acknowledged[neighbor]
      acknowledged[neighbor] = true
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
  'b' => ['c', 'd'],
  'c' => ['d'],
  'd' => ['a']
}

p breadth_first(graph, 'a') == ["a", "b", "c", "d"]

graph =
{
  'a' => ['b', 'c'],
  'b' => ['d', 'e'],
  'c' => ['f', 'g'],
  'd' => [],
  'e' => [],
  'f' => [],
  'g' => [],
}

p breadth_first(graph, 'a') == ["a", "b", "c", "d", "e", "f", "g"]
