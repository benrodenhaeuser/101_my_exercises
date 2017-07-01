# problem: traverse a graph in the breadth-first manner.

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
  colors = { vertex => :black }

  list_of_vertices = []

  while !queue.empty?
    next_vtx = queue.deq
    list_of_vertices << next_vtx
    graph[next_vtx].each do |neighbor|
      queue.enq(neighbor) unless colors[neighbor] == :black
      colors[neighbor] = :black
    end
  end

  list_of_vertices

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
