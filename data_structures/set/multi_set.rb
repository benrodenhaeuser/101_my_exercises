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
  end

  def include?(elem)
    self[elem] > 0
  end

  def to_a
    each_with_object([]) do |elem, array|
      array << elem
    end
  end

  def to_s
    # todo (or maybe not? Ruby's set class doesn't have it.)
  end

  def add(elem)
    @hash[elem] += 1
    self
  end

  def flatten(flattened = self.class.new)
    each_with_object(flattened) do |elem|
      if elem.instance_of?(self.class)
        elem.flatten(flattened)
      else
        flattened.add(elem)
      end
    end
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
    self
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

  def subset?(other_set)
    return false unless other_set.instance_of?(self.class)

    all? do |elem|
      @hash[elem] <= other_set[elem]
    end
  end
  alias <= subset?

  def proper_subset?(other_set)
    subset?(other_set) && !(self == other_set)
  end
  alias < subset?

  def superset?(other_set)
    other_set.subset?(self)
  end
  alias >= superset?

  def proper_superset?(other_set)
    superset?(other_set) && !(self == other_set)
  end
  alias > superset?

  def ==(other_set)
    subset?(other_set) && other_set.subset?(self)
  end
  alias eql? ==

  def hash
    @hash.hash
  end

  #
  # enum operations
  #

  def each
    return to_enum(&:each) unless block_given?
    @hash.each { |elem, count| count.times { yield(elem) } }
  end

  def map
    return to_enum(&:map) unless block_given?

    each_with_object(self.class.new) { |elem, new_set| new_set << yield(elem) }
  end

  def select
    return to_enum(&:select) unless block_given?

    each_with_object(self.class.new) do |elem, new_set|
      new_set << elem if yield(elem)
    end
  end

  protected

  def [](elem)
    @hash[elem]
  end

  def []=(elem, count)
    @hash[elem] = count
  end

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

  def subset?(other_set)
    return false unless other_set.instance_of?(self.class)

    all? do |elem|
      other_set.include?(elem)
    end
  end
end
