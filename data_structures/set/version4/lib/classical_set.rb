require_relative 'numeric_set'

class ClassicalSet < NumericSet
  @value_type = Integer
  @min_value = 0
  @max_value = 1

  def to_s
    '{' + each_elem.map(&:to_s).join(', ') + '}'
  end

  def inspect
    "#<#{self.class}: {" + each_elem.map(&:inspect).join(', ') + '}>'
  end
end
