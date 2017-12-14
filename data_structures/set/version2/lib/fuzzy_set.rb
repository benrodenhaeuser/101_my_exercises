class FuzzySet < GenericSet
  def initialize(input = {})
    raise ArgumentError unless input.instance_of?(Hash)
    raise ArgumentError unless input.values.all? { |val| valid_value?(val) }
    super()
    input.each_pair { |key, val| self[key] = val }
  end

  def max_value
    1.0
  end

  def min_value
    0.0
  end
end
