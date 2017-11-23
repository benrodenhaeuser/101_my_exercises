class MultiSet < MySet

  # self.[] is inherited
  # to_a is inherited
  # to_s is inherited
  # flatten is inherited

  def initialize(elems = [])
    @hash = Hash.new { |hash, key| hash[key] = 0 }
    merge(elems)
  end

  def size
    @hash.values.sum
  end

  # operations

  def &(enum)

  end

  def +(enum)

  end

  def -(enum)

  end

  def <<(elem)
    @hash[elem] += 1
  end

  def delete(elem)
    @hash[elem] -= 1 if @hash[elem] > 0
  end

  def subtract(enum)

  end

  def merge(enum)
    # let's start here.
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

  end

  def map

  end

  def select
  end

  protected

  def recursive_to_a
    # probably inheritable
  end

  private

  def do_with_enum(enum)
    # may be inheritable
  end
end
