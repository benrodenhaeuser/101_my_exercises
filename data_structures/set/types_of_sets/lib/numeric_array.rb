# to demonstrate that the code works with internal storage container other than hash. below, we use an array to represent a set of numbers.

# sets up the internal storage for NumericClassicalSet below.
class NumericArray
  def initialize
    @array = Array.new
  end

  def [](key)
    @array[key] ? @array[key] : 0
  end
  alias retrieve []

  def []=(key, value)
    @array[key] = value
  end

  def each_pair
    return to_enum(:each_pair) unless block_given?

    @array.each_index do |key|
      yield([key, self[key]]) if self[key] > 0
    end

    self
  end
  alias each each_pair
end

# represents sets of numbers
class NumericClassicalSet < NumericArray
  include SetLike

  def initialize(enum = [])
    raise ArgumentError unless enum.respond_to?(:each)
    super()
    enum.each { |key| add(key) }
  end

  def add(key, _ = 1)
    self[key] = 1
  end

  def delete(key, _ = 1)
    self[key] = 0
  end

  def valid_value?(value)
    [0, 1].include?(value)
  end

  def each_elem
    return to_enum(:each_elem) unless block_given?
    each_pair { |elem, _| yield(elem) }
  end
end
