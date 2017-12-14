class ClassicalSet < GenericSet
  def value_type
    Integer
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
    '{' + each_elem.map { |key| key.to_s }.join(', ') + '}'
  end

  def inspect
    "#<#{self.class}: {" +
      each_elem.map { |key| "#{key.inspect}" }.join(', ') + "}>"
  end
end
