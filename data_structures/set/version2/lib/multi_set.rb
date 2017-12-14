class MultiSet < GenericSet
  def initialize(input = {})
    raise ArgumentError unless input.respond_to?(:each)
    super()
    if input.instance_of?(Hash)
      raise ArgumentError unless input.values.all? { |val| valid_value?(val) }
      input.each_pair { |key, val| self[key] = val }
    else
      input.each { |key| insert(key) }
    end
  end

  def valid_value?(val)
    super && val.is_a?(Integer)
  end

  def max_value
    Float::INFINITY
  end

  def min_value
    0
  end

  def each_elem
    return to_enum(:each_elem) unless block_given?
    each_pair { |elem, val| val.times { yield(elem) } }
  end
end
