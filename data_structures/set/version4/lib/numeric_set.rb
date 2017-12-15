require_relative 'set_like'

class NumericSet
  include SetLike

  @value_type = Numeric
  @min_value = -Float::INFINITY
  @max_value = Float::INFINITY

  class << self
    attr_reader :value_type, :min_value, :max_value
  end

  def self.valid_value?(val)
    (@min_value..@max_value).cover?(val) && val.is_a?(@value_type)
  end

  def self.[](*list)
    set = new
    list.each { |key| set.insert(key) }
    set
  end

  def self.from_hash(hsh)
    raise(TypeError, 'Hash needed') unless hsh.instance_of?(Hash)
    set = new
    hsh.each_pair { |key, val| set.insert(key, val) }
    set
  end

  def initialize
    @hash = {}
    @size = 0
  end

  attr_reader :size

  def retrieve(key)
    @hash[key] ? @hash[key] : 0
  end
  alias [] retrieve

  def insert(key, val = 1)
    raise(ArgumentError, 'Invalid value') unless self.class.valid_value?(val)
    old_val = self[key]
    @hash[key] = [self[key] + val, self.class.max_value].min
    @size = (@size + (self[key] - old_val)).round(1)
  end

  def remove(key, val = 1)
    raise(ArgumentError, 'Invalid value') unless self.class.valid_value?(val)
    old_val = self[key]
    @hash[key] = [self[key] - val, self.class.min_value].max
    @size = (@size - (old_val - self[key])).round(2)
  end

  def each_pair
    return to_enum(:each_pair) unless block_given?

    @hash.each_pair do |key, val|
      yield([key, val]) if val != 0
    end

    self
  end
  alias each each_pair

  def each_elem
    return to_enum(:each_elem) unless block_given?
    each_pair { |key, val| val.ceil.times { yield(key) } }
    self
  end
end
