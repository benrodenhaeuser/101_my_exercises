require_relative 'numeric_set'

class MultiSet < NumericSet
  @value_type = Integer
  @min_value = 0
  @max_value = Float::INFINITY
end
