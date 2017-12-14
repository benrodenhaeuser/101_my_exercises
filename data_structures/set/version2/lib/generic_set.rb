require_relative 'set_like'

class GenericSet
  include SetLike

  attr_reader :size

  def self.[](*list)
    new(list)
  end

  def self.from_hash(hsh)
    raise TypeError, "Hash needed" unless hsh.instance_of?(Hash)
    set = new
    hsh.each_pair { |key, val| set.add(key, val) }
    set
  end

  def initialize(list = [])
    @hash = Hash.new
    @size = 0
    list.each { |key| add(key) }
  end

  def value_type
    Numeric
  end

  def max_value
    Float::INFINITY
  end

  def min_value
    -Float::INFINITY
  end

  def valid_value?(val)
    (min_value..max_value).include?(val) && val.kind_of?(value_type)
  end

  def retrieve(key)
    @hash[key] ? @hash[key] : 0
  end
  alias [] retrieve

  def add(key, val = 1)
    raise ArgumentError, "Invalid value" unless valid_value?(val)
    old_val = self[key]
    @hash[key] = [self[key] + val, max_value].min
    @size += self[key] - old_val
  end

  def subtract(key, val = 1)
    raise ArgumentError, "Invalid value" unless valid_value?(val)
    old_val = self[key]
    @hash[key] = [self[key] - val, min_value].max
    @size -= old_val - self[key]
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
