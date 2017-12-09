# Using an array instead of a hash for sets of numbers works using our approach, but the fact that there are no default values for arrays is problematic.

class NumericArray
  def initialize
    @array = Array.new
  end

  def [](key)
    @array[key]
  end
  alias indicator []

  def []=(key, value)
    @array[key] = value
  end

  def each_pair
    return to_enum(:each_pair) unless block_given?

    @array.each do |key|
      yield([key, @array[key]]) if @array[key] > 0
    end

    self
  end
  alias each each_pair
end


class NumericClassicalSet < NumericArray
  include SetLike

  def initialize(enum = [])
    raise ArgumentError unless enum.respond_to?(:each)
    super()
    enum.each { |key| add(key) }
  end

  def add(key)
    self[key] = 1
    # HACK:
    @array.map! do |elem|
      if elem.nil?
        0
      else
        elem
      end
    end
  end

  def delete(key)
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
