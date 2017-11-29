class Bag
  include Enumerable

  #
  # basics
  #

  def self.[](*enum)
    self.new(enum)
  end

  def initialize(enum = [])
    @hash = Hash.new(0)
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
    recursive_to_a.to_s.gsub(/\[/, '{').gsub(/\]/, '}')
  end

  def add(elem)
    @hash[elem] += 1
    self
  end

  def delete(elem)
    @hash[elem] -= 1
    self
  end

  def delete_all(elem)
    @hash[elem] = 0
    self
  end

  def count(*list_of_items)
    case list_of_items.length
    when 0 then self.size
    when 1 then self[list_of_items.first]
    else
      raise ArgumentError
    end
  end

  def flatten(flat = self.class.new)
    each_with_object(flat) do |elem|
      if elem.instance_of?(self.class)
        elem.flatten(flat)
      else
        flat.add(elem)
      end
    end
  end

  #
  # iterators
  #

  def each
    return to_enum(&:each) unless block_given?
    @hash.each { |elem, count| count.times { yield(elem) } }
  end

  def map
    return to_enum(&:map) unless block_given?

    each_with_object(self.class.new) do |elem, new_set|
      new_set.add(yield(elem))
    end
  end

  def select
    return to_enum(&:select) unless block_given?

    each_with_object(self.class.new) do |elem, new_set|
      new_set.add(elem) if yield(elem)
    end
  end

  #
  # operations with enums: destructive
  #

  def sum!(enum)
    do_with(enum) { |elem| add(elem) }
    self
  end

  def union!(enum)
    do_with(enum) do |elem|
      self[elem] = [count(elem), enum.count(elem)].max
    end
    self
  end

  alias :merge :union!

  def difference!(enum)
    do_with(enum) do |elem|
      self[elem] = [0, count(elem) - enum.count(elem)].max
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

  def difference(enum)
    the_difference = self.dup
    the_difference.difference!(enum)
  end

  def intersection(enum)
    do_with(enum).with_object(self.class.new) do |elem, intersection|
      intersection[elem] = [self[elem], enum.count(elem)].min
    end
  end

  #
  # predicates (with other set)
  #

  def subset?(other_set)
    return false unless other_set.instance_of?(self.class)

    all? do |elem|
      self[elem] <= other_set[elem]
    end
  end
  alias <= subset?

  def proper_subset?(other_set)
    subset?(other_set) && self != other_set
  end
  alias < subset?

  def superset?(other_set)
    other_set.subset?(self)
  end
  alias >= superset?

  def proper_superset?(other_set)
    superset?(other_set) && self != other_set
  end
  alias > superset?

  def equivalent?(other_set)
    subset?(other_set) && other_set.subset?(self)
  end
  alias :== :equivalent?
  alias :eql? :equivalent?

  def hash
    @hash.hash
  end

  protected

  def [](elem)
    @hash[elem]
  end

  def []=(elem, count)
    @hash[elem] = count
  end

  def do_with(enum)
    raise ArgumentError unless enum.kind_of?(Enumerable)
    raise ArgumentError unless enum.each.instance_of?(Enumerator)

    return enum.each unless block_given?
    enum.each { |elem| yield elem }
  end

  def all_with?(enum)
    return false unless enum.kind_of?(Enumerable)

    (to_a | enum.to_a).all? { |item| yield(item) }
  end

  def recursive_to_a
    each_with_object([]) do |elem, array|
      if elem.instance_of?(self.class)
        array << elem.recursive_to_a
      else
        array << elem
      end
    end
  end
end

class Set < Bag
  def size
    @hash.keys.count
  end

  def each
    return to_enum(&:each) unless block_given?

    @hash.each_key { |elem| yield(elem) if self[elem] > 0 }
  end

  def subset?(other_set)
    return false unless other_set.instance_of?(self.class)

    all? do |elem|
      other_set.include?(elem)
    end
  end

  # protected

  def hash
    @hash.keys.map(&:hash).sum
  end
end
