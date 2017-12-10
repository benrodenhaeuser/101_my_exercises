# requires client to implement
# :add, :delete, :retrieve, :each
module SetLike
  include Enumerable

  # preliminaries

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

  def update(key, value)
    delete(key, retrieve(key))
    add(key, value) if value > 0
  end

  def remove(key)
    update(key, 0)
  end

  def to_s
    '{' + map { |key, val| "(#{key}: #{val})" }.join(', ') + '}'
  end

  def inspect
    "#<#{self.class}: " +
      map { |key, val| "(#{key.inspect}: #{val})" }.join(', ') + ">"
  end

  def flatten(flat = self.class.new)
    each.with_object(flat) do |(key, val), _|
      if key.instance_of?(self.class)
        key.flatten(flat)
      else
        flat.add(key, val)
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

  # operations with other

  def union!(other)
    do_with(other) do |key, _|
      update(
        key,
        [retrieve(key), other.retrieve(key)].max
      )
    end
    self
  end

  def union(other)
    dup.union!(other)
  end
  alias | union

  def difference!(other)
    do_with(other) do |key, _|
      update(
        key,
        [0, retrieve(key) - other.retrieve(key)].max
      )
    end
    self
  end

  def difference(other)
    dup.difference!(other)
  end
  alias - difference

  def intersection!(other)
    each do |key, _|
      update(
        key,
        intersection(other).retrieve(key)
      )
    end
  end

  # todo: this really needs to be done some other way.
  def intersection(other)
    do_with(other).with_object(self.class.new) do |(key, _), the_intersection|
      the_intersection.update(
        key,
        [retrieve(key), other.retrieve(key)].min
      )
    end
  end
  alias & intersection

  def do_with(other)
    raise ArgumentError unless other.instance_of?(self.class)

    return other.each unless block_given?
    other.each { |key, val| yield([key, val]) }
  end
  private :do_with

  # comparison with other

  def subset?(other)
    return false unless other.instance_of?(self.class)

    all? do |key, _|
      retrieve(key) <= other.retrieve(key)
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
