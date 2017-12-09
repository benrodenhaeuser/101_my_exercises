class NumericMap
  def initialize
    @hash = Hash.new(0)
  end

  def []=(key, val)
    raise ArgumentError unless valid_value?(val)
    @hash[key] = val
  end

  def [](key)
    @hash[key]
  end
  alias indicator []

  def each_pair
    return to_enum(:each_pair) unless block_given?

    @hash.each_pair do |key, val|
      yield([key, val]) if val > 0
    end

    self
  end
  alias each each_pair

  def valid_value?(val)
    val.is_a?(Numeric)
  end
end
