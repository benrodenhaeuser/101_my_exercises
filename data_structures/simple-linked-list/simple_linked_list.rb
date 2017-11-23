module BookKeeping
  VERSION = 1
end

class SimpleLinkedList
  def initialize(list = nil)
    if list
      list = list.to_a
      while !list.empty?
        push(Element.new(list.shift))
      end
    else
      @top = nil
    end
  end

  def push(element)
    element.next = @top
    @top = element
    self
  end

  def pop
    element = @top
    @top = element.next if !element.nil?
    element
  end

  def to_a
    array = []
    element = @top
    while element
      array.push(element.datum)
      element = element.next
    end
    array
  end

  def reverse!
    return self if @top.nil?

    current_elem = @top
    next_elem = @top.next
    @top.next = nil

    temp_elem = Element.new

    while next_elem
      temp_elem.next = next_elem.next
      next_elem.next = current_elem
      current_elem = next_elem
      next_elem = temp_elem.next
    end

    @top = current_elem

    self
  end
end

class Element
  def initialize(datum = nil)
    @datum = datum
    @next = nil
  end

  def datum
    @datum
  end

  def next
    @next
  end

  def next=(element)
    @next = element
  end
end
