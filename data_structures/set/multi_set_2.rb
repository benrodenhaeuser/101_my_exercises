require_relative 'my_set'

class MultiSet
  include Enumerable

  def self.[](*enum)
    self.new(enum)
  end

  def initialize(enum = [])
    @hash = Hash.new { |hash, key| hash[key] = 0 }
    merge(enum)
  end

  def size
    @hash.values.sum
    # TODO: or should we keep track of this on our own?
    # this seems to be an improvement, because this is not constant time for sure.
  end

  def to_a
    each_with_object([]) do |elem, array|
      array << elem
    end
  end

  def to_s
    # todo
  end

  def [](elem)
    @hash[elem]
  end

  alias :count :[]

  def []=(elem, count)
    @hash[elem] = count
  end

  def add(elem)
    @hash[elem] += 1
    self
  end

  def flatten
    # TODO
  end


  #
  # operations with enums: destructive
  #

  def sum!(enum)
    do_with_enum(enum) { |elem| @hash[elem] += 1}
    self
  end

  def union!(enum)
    do_with_enum(enum) do |elem|
      self[elem] = [self[elem], enum.count(elem)].max
    end
    self
  end

  alias :merge :union!

  def difference!(enum)
    do_with_enum(enum) do |elem|
      self[elem] = [0, self[elem] - enum.count(elem)].max
    end
  end

  alias :subtract :difference!

  #
  # operations with enums: non-destructive
  #

  def sum(enum)
    the_sum = self.dup
    the_sum.sum!(enum)
  end

  def union(enum)
    the_union = self.dup
    the_union.union!(enum)
  end

  def intersection(enum)
    do_with_enum(enum).with_object(self.class.new) do |elem, intersection|
      intersection[elem] = [self[elem], enum.count(elem)].min
    end
  end

  def difference(enum)
    the_difference = self.dup
    the_difference.difference!(enum)
  end

  #
  # predicates
  #

  # TODO


  #
  # enum operations
  #

  def each
    return to_enum(&:each) unless block_given?

    @hash.each { |elem, count| count.times { yield(elem) } }
  end

  def map
    # todo
  end

  def select
    # todo
  end

  private

  def do_with_enum(enum)
    raise ArgumentError unless enum.respond_to?(:each)
    raise ArgumentError unless enum.each.instance_of?(Enumerator)
    raise ArgumentError unless enum.respond_to?(:count)

    return enum.each unless block_given?
    enum.each { |elem| yield elem }
  end
end

class Set < MultiSet
  def size
    @hash.keys.count
  end

  def each
    return to_enum(&:each) unless block_given?

    @hash.each_key { |elem| yield(elem) }
  end

  undef_method :sum # TODO: do we need to keep it?
  undef_method :sum!
end
