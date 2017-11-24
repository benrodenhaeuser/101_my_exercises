# A reimplementation of (part of) the Set class that is part of Ruby's Standard
# Library.
#
# Comments without parentheses are copied from the documentation of the Set
# class.

class MySet
  include Enumerable

  def self.[](*elems)
    self.new(elems)
  end

  def initialize(elems = [])
    @hash = Hash.new
    merge(elems)
  end

  # Converts the set to an array. The order of elements is uncertain.
  def to_a
    @hash.keys
  end

  def size
    @hash.size
  end

  # (Returns a string representation of the set (with enclosing curly
  # braces). Recursively stringifies contained sets in the same way.)
  def to_s
    recursive_to_a.to_s.gsub(/\[/, '{').gsub(/\]/, '}')
  end

  # Returns a new set that is a copy of the set, flattening each containing set
  # recursively.
  def flatten(flattened = self.class.new)
    each_with_object(flattened) do |elem|
      if elem.instance_of?(self.class)
        elem.flatten(flattened)
      else
        flattened << elem
      end
    end
  end

  # Returns a new set containing elements common to the set and the given
  # enumerable object.
  def &(enum)
    do_with_enum(enum).with_object(self.class.new) do |elem, intersection|
      intersection << elem if include?(elem)
    end
  end
  alias :intersection :&

  # Returns a new set built by merging the set and the elements of the given
  # enumerable object.
  def +(enum)
    do_with_enum(enum).with_object(self.dup) do |elem, union|
      union << elem
    end
  end

  alias :union :+

  # Returns a new set built by duplicating the set, removing every element that
  # appears in the given enumerable object.
  def -(enum)
    do_with_enum(enum).with_object(self.dup) do |elem, difference|
      difference.delete(elem)
    end
  end

  alias :difference :-

  # Adds the given object to the set and returns self. Use merge to add many
  # elements at once.
  def <<(elem)
    @hash[elem] = 1
    self
  end

  alias :add :<<

  # Deletes the given object from the set and returns self. Use subtract to
  # delete many items at once.
  def delete(elem)
    @hash.delete(elem)
    self
  end

  # Deletes every element that appears in the given enumerable object and
  # returns self.
  def subtract(enum)
    do_with_enum(enum) { |elem| delete(elem) }
    self
  end

  # Merges the elements of the given enumerable object to the set and returns
  # self.
  def merge(enum)
    do_with_enum(enum) { |elem| add(elem) }
    self
  end

  # Returns true if the set is a subset of the given set.
  def <=(other_set)
    return false unless other_set.instance_of?(self.class)

    all? do |elem|
      other_set.include?(elem)
    end
  end

  alias :subset? :<=

  def ==(other_set)
    return false unless other_set.instance_of?(self.class)

    return false unless size == other_set.size
    self <= other_set
  end

  # Returns true if the set is a superset of the given set.
  def >=(other_set)
    other_set <= self
  end

  alias :superset :>=

  # Returns true if the set is a proper subset of the given set.
  def <(other_set)
    return false unless other_set.instance_of?(self.class)

    return false if size == other_set.size
    self <= other_set
  end

  alias :proper_subset :<

  # Returns true if the set is a proper superset of the given set.
  def >(other_set)
    other_set < set
  end

  alias :proper_superset :>

  # Returns true if two sets are equal. The equality of each couple of elements is defined according to Object#eql?.

  # Calls the given block once for each element in the set, passing the element as parameter. Returns an enumerator if no block is given.
  def each
    return to_enum(&:each) unless block_given?

    @hash.each_key { |elem| yield(elem) }
  end

  # (overriding Enumerable#map)
  def map
    return to_enum(&:map) unless block_given?

    each_with_object(self.class.new) { |elem, new_set| new_set << yield(elem) }
  end

  # (overriding Enumerable#select)
  def select
    return to_enum(&:select) unless block_given?

    each_with_object(self.class.new) do |elem, new_set|
      new_set << elem if yield(elem)
    end
  end

  protected

  # (Converts the set to an array, while also recursively converting contained sets to an array. Not part of the Set class.)
  def recursive_to_a
    @hash.keys.each_with_object([]) do |elem, array|
      if elem.instance_of?(self.class)
        array << elem.recursive_to_a
      else
        array << elem
      end
    end
  end

  private

  # (The Set class does not require `enum.each` to return
  # an Enumerator, like we do below. We do it since we like to be able to call
  # `with_object` on `enum.each`.)
  def do_with_enum(enum)
    raise ArgumentError unless enum.respond_to?(:each)
    raise ArgumentError unless enum.each.instance_of?(Enumerator)

    return enum.each unless block_given?
    enum.each { |elem| yield elem }
  end
end
