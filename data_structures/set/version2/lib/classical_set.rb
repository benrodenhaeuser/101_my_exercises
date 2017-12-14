class ClassicalSet < GenericSet
  def initialize(enum = [])
    raise ArgumentError unless enum.respond_to?(:each)
    super()
    enum.each { |key| insert(key) }
  end

  def max_value
    1
  end

  def min_value
    0
  end

  def each_elem
    return to_enum(:each_elem) unless block_given?
    each_pair { |elem, _| yield(elem) }
  end

  def to_s
    '{' + map { |key, _| key.to_s }.join(', ') + '}'
  end

  def inspect
    "#<#{self.class}: {" +
      map { |key, val| "#{key.inspect}" }.join(', ') + "}>"
  end
end
