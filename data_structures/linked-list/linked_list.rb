class Deque
  def initialize
    @head = nil
    @tail = nil
  end

  def push(data)
    node = Node.new(data)

    case @head
    when nil
      @head = node
      @tail = node
    when @tail
      @head = node
      @head.next = @tail
      @tail.prev = @head
    else
      node.next = @head
      @head.prev = node
      @head = node
    end

    self
  end

  def pop
    return nil if @head.nil?

    node = @head

    case @head
    when @tail
      @head = nil
      @tail = nil
    else
      @head = @head.next
      @head.prev = nil
    end

    node.data
  end

  def unshift(data)
    node = Node.new(data)

    case @tail
    when nil
      @tail = node
      @head = node
    when @head
      @tail = node
      @head.next = @tail
      @tail.prev = @head
    else
      node.prev = @tail
      @tail.next = node
      @tail = node
    end

    self
  end

  def shift
    return nil if @tail.nil?

    node = @tail

    case @tail
    when @head
      @head = nil
      @tail = nil
    else
      @tail = @tail.prev
      @tail.next = nil
    end

    node.data
  end

  private

  class Node

    attr_reader :data
    attr_accessor :prev, :next

    def initialize(data = nil)
      @data = data
      @next = nil
      @prev = nil
    end
  end

  private_constant :Node
end
