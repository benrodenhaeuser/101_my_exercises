class Bag
  include Enumerable

  def self.[](*enum)
    new(enum)
  end

  def initialize(enum = [])
    @hash = Hash.new(0)
    merge(enum)
  end

  def each
    return to_enum(&:each) unless block_given?
    @hash.each { |elem, count| count.times { yield(elem) } }
  end

  def count(item = nil)
    item ? each.count(item) : size
  end

  def include?(elem)
    count(elem) > 0
  end

  def size
    each.count
  end

  def to_a
    each.to_a
  end

  def to_s
    recursive_to_a.to_s.tr('[]', '{}')
  end

  def inspect
    "#<Bag: #{to_s}>"
  end

  def add(elem)
    @hash[elem] = count(elem) + 1
    self
  end

  def delete(elem)
    @hash[elem] = count(elem) - 1
    self
  end

  def delete_all(elem)
    @hash[elem] = 0
    self
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
  alias merge union!

  def difference!(enum)
    do_with(enum) do |elem|
      self[elem] = [0, count(elem) - enum.count(elem)].max
    end
    self
  end
  alias subtract difference!

  #
  # operations with enums: non-destructive
  #

  def sum(enum)
    the_sum = dup
    the_sum.sum!(enum)
  end

  def union(enum)
    the_union = dup
    the_union.union!(enum)
  end

  def difference(enum)
    the_difference = dup
    the_difference.difference!(enum)
  end

  def intersection(enum)
    do_with(enum).with_object(self.class.new) do |elem, intersection|
      intersection[elem] = [count(elem), enum.count(elem)].min
    end
  end

  #
  # predicates (with other set)
  #

  def subset?(other_set)
    return false unless other_set.instance_of?(self.class)

    all? do |elem|
      count(elem) <= other_set.count(elem)
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
  alias == equivalent?
  alias eql? equivalent?

  def hash
    each.map(&:hash).sum
  end

  protected

  def []=(elem, count)
    @hash[elem] = count
  end

  def do_with(enum)
    raise ArgumentError unless enum.is_a?(Enumerable)
    raise ArgumentError unless enum.each.instance_of?(Enumerator)

    return enum.each unless block_given?
    enum.each { |elem| yield elem }
  end

  def all_with?(enum)
    return false unless enum.is_a?(Enumerable)

    (to_a | enum.to_a).all? { |item| yield(item) }
  end

  def recursive_to_a
    each_with_object([]) do |elem, array|
      array <<
        if elem.instance_of?(self.class)
          elem.recursive_to_a
        else
          elem
        end
    end
  end
end

class Set < Bag
  def each
    return to_enum(&:each) unless block_given?

    @hash.each_key { |elem| yield(elem) if @hash[elem] > 0 }
  end

  def inspect
    "#<Set: #{to_s}>"
  end
end
