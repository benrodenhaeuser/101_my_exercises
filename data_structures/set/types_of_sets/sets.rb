module SetOperations

  # SUM

  # for fuzzy sets, this is the "bounded sum"
  # see here: https://encyclopedia2.thefreedictionary.com/bounded+sum
  def sum!(other)
    do_with(other) { |elem| add(elem) }
    self
  end

  def sum(enum)
    dup.sum!(enum)
  end

  # UNION

  def union!(other) # max
    do_with(other) do |elem|
      self[elem] = [self[elem], other[elem]].max
    end
    self
  end

  def union(enum)
    dup.union!(enum)
  end

  # DIFFERENCE

  # for fuzzy sets, this is called "bounded difference". sometimes, this is also called truncated subtraction (https://en.wikipedia.org/wiki/Monus#Natural_numbers)
  def difference!(enum)
    do_with(other) do |elem|
      self[elem] = [0, self[elem] - other[elem]].max
    end
    self
  end
  alias subtract difference!

  def difference(other)
    dup.difference!(other)
  end

  # INTERSECTION

  def intersection!(other)
    each do |elem|
      @hash[elem] = intersection(other)[elem]
    end
  end

  def intersection(other)
    do_with(other).with_object(self.class.new) do |elem, intersection|
      intersection[elem] = [self[elem], other[elem]].min
    end
  end

  def do_with(other)
    raise ArgumentError unless other.instance_of?(self.class)

    return other.each unless block_given?
    other.each { |elem| yield elem }
  end
end

# INCLUSION and EQUIVALENCE

module SetInclusion
  def subset?(other)
    return false unless other.instance_of?(self.class)

    all? do |elem|
      self[elem] <= other[elem]
    end
  end
  alias <= subset?

  def proper_subset?(other)
    subset?(other) && self != other
  end
  alias < subset?

  def superset?(other)
    other.subset?(self)
  end
  alias >= superset?

  def proper_superset?(other)
    superset?(other) && self != other_set
  end
  alias > superset?

  def equivalent?(other)
    subset?(other) && other.subset?(other)
  end
  alias == equivalent?
  alias eql? equivalent?

  def hash
    each.map(&:hash).sum
  end
end

# purpose : provide and abstract away data structure for working with
# sets: this class could be replaced by a different one, if we chose to
# use a different kind of collaborator class.

class BasicSet
  include Enumerable
  include SetInclusion
  include SetOperations

  def self.[](hsh)
    new(hsh)
  end

  def initialize(hsh = {})
    @hash = Hash.new(0)
    merge(hsh)
  end

  def merge(hash)
    raise ArgumentError unless hash.instance_of?(Hash)
    hash.each { |elem, value| self[elem] = value }
  end

  def [](elem)
    @hash[elem]
  end

  def []=(elem, value)
    @hash[elem] = value
  end

  def each
    return to_enum(&:each) unless block_given?
    @hash.each { |elem, value| yield(elem, value) }
  end

  def to_h
    @hash.select { |_, value| value > 0 }
  end
end

class MultiSet < BasicSet
  def []=(elem, value)
    raise ArgumentError unless value.kind_of?(Integer) && value.positive?
    super
  end

  def add(elem)
    self[elem] += 1
  end
end

class ClassicalSet < BasicSet
  def []=(elem, value)
    raise ArgumentError unless [0, 1].include?(value)
    super
  end

  def add(elem)
    self[elem] = 1
  end
end

class FuzzySet < BasicSet
  def []=(elem, value)
    raise ArgumentError unless (0.0..1.0).include?(value)
    super
  end

  def add(value, elem)
    self[elem] = [self[elem] + value, 1].min
  end
end
