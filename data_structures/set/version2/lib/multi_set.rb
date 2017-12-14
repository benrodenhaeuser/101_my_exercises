class MultiSet < GenericSet
  def value_type
    Integer
  end

  def min_value
    0
  end

  def each_elem
    return to_enum(:each_elem) unless block_given?
    each_pair { |elem, val| val.times { yield(elem) } }
  end
end
