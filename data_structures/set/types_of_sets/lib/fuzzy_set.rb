class FuzzySet < NumericMap
  include SetLike

  def initialize(hsh = {})
    raise ArgumentError unless valid_hash?(hsh)
    super()
    hsh.each_pair { |key, val| self[key] = val }
  end

  def valid_hash?(hsh)
    hsh.instance_of?(Hash) &&
      hsh.values.all? { |val| valid_value?(val) }
  end
  private :valid_hash?

  def add(key, degree = 1)
    raise ArgumentError unless valid_value?(degree)
    self[key] = [self[key] + degree, 1].min
  end

  def delete(key, degree = 1)
    raise ArgumentError unless valid_value?(degree)
    self[key] = [self[key] - degree, 0].max
  end

  def valid_value?(val)
    (0.0..1.0).include?(val)
  end

  # (custom methods for this set type)

  def sum!(other)
    do_with(other) { |key, val| self[key] += val }
    self
  end

  def sum(other)
    dup.sum!(other)
  end
  alias + sum
end
