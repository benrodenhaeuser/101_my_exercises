# depth-first search vs breadth-first search

# -----------------------------------------------------------------------------
# comments
# -----------------------------------------------------------------------------

=begin

the two implementations below are written the way they are to emphasize the
similarity between dfs and bfs.

one could say that the only real difference is that breadth-first search uses
a queue, depth-first search uses a stack.

- the queue/stack represents vertices we plan to visit.
- the process of enqueuing vertices/pushing vertices on the stack represents
  "visiting" these vertices.
- we are, on the other hand, "processing" a vertex as we dequeue a vertex/pop
  it from the stack.
- the implementations below make the distinction between "visiting" and
  "processing" explicit, even though that is not necessary to get the
  respective algorithms to work.

=end

# -----------------------------------------------------------------------------
# breadth-first search (queue)
# -----------------------------------------------------------------------------

# returns list of vertices in the order in which they were processed

require 'thread'

def breadth_first(graph, source)
  queue = Queue.new
  queue.enq(source)
  visited = { source => true }

  processed = {}

  while !queue.empty?
    vtx = queue.deq
    processed[vtx] = true
    graph[vtx].each do |neighbor|
      queue.enq(neighbor) unless visited[neighbor]
      visited[neighbor] = true
    end
  end

  processed.keys

end

# -----------------------------------------------------------------------------
# depth-first search (stack )
# -----------------------------------------------------------------------------

# returns list of vertices in the order in which they were processed

def depth_first(graph, source)
  stack = [source]
  visited = { source => true }

  processed = {}

  while !stack.empty?
    vtx = stack.pop
    processed[vtx] = true
    graph[vtx].each do |neighbor|
      stack.push(neighbor) unless visited[neighbor]
      visited[neighbor] = true
    end
  end

  processed.keys

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
p depth_first(graph, 'a')  == ["a", "c", "d", "b"]

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
p depth_first(graph, 'a')  == ["a", "c", "g", "f", "b", "e", "d"]
