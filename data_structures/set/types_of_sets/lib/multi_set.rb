class MultiSet < NumericMap
  include SetLike

  def initialize(input = {})
    raise ArgumentError unless input.respond_to?(:each)
    super()
    if input.instance_of?(Hash)
      raise ArgumentError unless valid_hash?(input)
      input.each_pair { |key, val| self[key] = val }
    else
      input.each { |key| add(key) }
    end
  end

  def add(key, value = 1)
    self[key] += value
  end

  def delete(key, value = 1)
    self[key] = [self[key] - value, 0].max
  end

  def valid_hash?(hsh)
    hsh.values.all? do |val|
      valid_value?(val)
    end
  end

  def valid_value?(val)
    val.is_a?(Integer) && val >= 0
  end

  # custom methods for this set type

  def sum!(other)
    do_with(other) { |key, val| self[key] += val }
    self
  end

  def sum(other)
    dup.sum!(other)
  end
  alias + sum

  def each_elem
    return to_enum(:each_elem) unless block_given?
    each_pair { |elem, val| val.times { yield(elem) } }
  end
end
