class GenericSet
  include SetLike

  def initialize
    @hash = Hash.new
  end

  def max_value
    Float::INFINITY
  end

  def min_value
    -Float::INFINITY
  end

  def valid_value?(val)
    (min_value..max_value).include?(val)
  end

  def update(key, val)
    raise ArgumentError unless valid_value?(val)
    @hash[key] = val
  end
  alias []= update

  def retrieve(key)
    @hash[key] ? @hash[key] : 0
  end
  alias [] retrieve

  def insert(key, val = 1)
    self[key] = [self[key] + val, max_value].min
  end

  def delete(key, val = 1)
    self[key] = [self[key] - val, min_value].max
  end

  def each_pair
    return to_enum(:each_pair) unless block_given?

    @hash.each_pair do |key, val|
      yield([key, val]) if val > 0
    end

    self
  end
  alias each each_pair
end
