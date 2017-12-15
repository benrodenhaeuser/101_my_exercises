require_relative 'numeric_set'

class FuzzySet < NumericSet
  @value_type = Numeric
  @min_value = 0
  @max_value = 1
end
