require_relative 'my_set'

# reference: https://github.com/maraigue/multiset

class MultiSet

  # self.[] is inherited
  # flatten is inherited

  # TODO: to_s works out differently

  def initialize(elems = [])
    @hash = Hash.new { |hash, key| hash[key] = 0 }
    multi_sum(elems)
  end

  def size
    @hash.values.sum
  end

  def to_a
    @hash.each_with_object([]) do |(key, value), array|
      value.times { array << key }
    end
  end

  # we need a way to access the *count* of the elems.
  def [](elem)
    @hash[elem]
  end

  alias count :[]

  def []=(elem, value)
    @hash[elem] = value
  end

  def clean
    # delete the elems for which count is 0.
    # but how to do this?
  end

  # operations

  # requires enum.class to implement count (arrays do it)
  # could we get by without this by just having the elems yielded to us?
  def &(enum)
    each_with_object(self.dup) do |elem, intersection|
      self[elem] = [self[elem], other.count(elem)].min
    end
  end

  def +(enum)

  end

  def -(enum)

  end

  # this has to be different for ordinary sets
  def <<(elem)
    @hash[elem] += 1
  end

  # is this the right term for multisets?
  def delete(elem)
    @hash[elem] -= 1 if @hash[elem] > 0
  end


  def subtract(enum)

  end

  # notice that this is a destructive method
  def multi_sum(enum)
    do_with_enum(enum) { |elem| @hash[elem] += 1}
  end

  def merge(enum)
    # define in terms of add
  end

  # predicates

  def <=(other_set)
    # perhaps definable with help of super?
  end

  def >=(other_set)

  end

  def <(other_set)
  end

  def >(other_set)

  end

  def ==(other_set)

  end

  # enum-type methods

  def each
    # we need to yield elements several times! so this needs to be adapted.
  end

  def map

  end

  def select
  end
end
