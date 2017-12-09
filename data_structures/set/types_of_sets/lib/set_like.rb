module SetLike
  # requires client to implement
  # :[], :[]=, :each

  # todo: perhaps replace :[]= with :add and :delete (?)
  # i.e.:
  # :score, :add, :delete, :each
  # perhaps multiplicity?
  # is there a better (shorter) name for indicator? score, perhaps?
  # this makes sense insofar as a set is characterized by indicator, add and delete
  # we could then define the setter in terms of :indicator, :add and :delete, as follows:
  #
  # def update(key, value)
  #   delete(key, indicator(key))
  #   add(key, value)
  # end

  # update is like renew_count that is used in multiset gem.

  # however, there is a danger of circularity, because in our case, the client class also defines []=, and uses it to define add, delete etc.

  # so perhaps, what we should simply do is use different notation?

  # if we do this, we would not have to change so much, actually.
  # but we would make the SetLike class more independent of the underlying NumericMap.
  # because the way it is implemented right now, SetLike depends on both NumericMap and Fuzzy Set.

  include Enumerable

  # "basics"

  def keys
    each.map(&:first)
  end

  def values
    each.map(&:last)
  end

  def size
    values.sum
  end

  def include?(elem)
    keys.include?(elem)
  end

  def remove(key)
    self[key] = 0
  end

  def to_s
    '{' + map { |key, val| "(#{key}: #{val})" }.join(', ') + '}'
  end

  def inspect
    "#<#{self.class}: " +
      map { |key, val| "(#{key.inspect}: #{val})" }.join(', ') + ">"
  end

  def flatten(flat = self.class.new)
    each.with_object(flat) do |(key, value), _|
      if key.instance_of?(self.class)
        key.flatten(flat)
      else
        flat.add(key, value)
      end
    end
  end

  def hash
    each.map(&:hash).sum
  end

  def dup
    duplicate = self.class.new
    duplicate.instance_variable_set(:@hash, @hash.dup)
    duplicate
  end

  # operations with other set

  def union!(other)
    do_with(other) do |key, _|
      self[key] = [self[key], other[key]].max
    end
    self
  end

  def union(other)
    dup.union!(other)
  end
  alias | union

  def difference!(other)
    do_with(other) do |key, _|
      self[key] = [0, self[key] - other[key]].max
    end
    self
  end

  def difference(other)
    dup.difference!(other)
  end
  alias - difference

  def intersection!(other)
    each do |key, _|
      self[key] = intersection(other)[key]
    end
  end

  def intersection(other)
    do_with(other).with_object(self.class.new) do |(key, _), the_intersection|
      the_intersection[key] = [indicator(key), other.indicator(key)].min
    end
  end
  alias & intersection

  def do_with(other)
    raise ArgumentError unless other.instance_of?(self.class)

    return other.each unless block_given?
    other.each { |key, val| yield([key, val]) }
  end
  private :do_with

  # inclusion and equivalence

  def subset?(other)
    return false unless other.instance_of?(self.class)

    all? do |key, _|
      self[key] <= other[key]
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
    superset?(other) && self != other
  end
  alias > superset?

  def equivalent?(other)
    subset?(other) && other.subset?(self)
  end
  alias == equivalent?
  alias eql? equivalent?
end
