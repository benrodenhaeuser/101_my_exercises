# iterative implementations of insert, search, each

module BookKeeping
  VERSION = 1
end

class Bst
  include Enumerable

  def initialize(data)
    @root = Node.new(data)
  end

  def insert(data)
    node = @root

    loop do
      break unless node.data

      if node.data >= data
        node = node.left ||= Node.new
      else
        node = node.right ||= Node.new
      end
    end

    node.data = data
  end

  def search(data)
    node = @root

    loop do
      break nil if node.nil?
      break data if node.data == data

      if node.data >= data
        node = node.left
      else
        node = node.right
      end
    end
  end

  def each
    return to_enum(&:each) unless block_given?

    stack = []
    node = @root

    loop do
      if node
        stack.push(node)
        node = node.left
      else
        break if stack.empty?
        node = stack.pop
        yield node.data
        node = node.right
      end
    end

    self
  end

  def data
    @root.data
  end

  def left
    @root.left
  end

  def right
    @root.right
  end

  private

  class Node
    attr_accessor :data, :left, :right

    def initialize(data = nil)
      @data = data
    end
  end

  private_constant :Node
end
