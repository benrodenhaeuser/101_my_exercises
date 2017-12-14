class FuzzySet < GenericSet
  def value_type
    Numeric
  end

  def max_value
    1
  end

  def min_value
    0
  end
end
