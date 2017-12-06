class Bag
  include Enumerable

  def initialize(enum = [])
    @hash = Hash.new(0)
    merge(enum)
  end

  def multiplicity(elem)
    @hash[elem]
  end

  def count(elem = nil)
    elem ? multiplicity(elem) : size
  end

  def each
    return to_enum(&:each) unless block_given?
    @hash.each_key { |elem| count(elem).times { yield(elem) } }
  end

  def union!(enum)
    do_with(enum) do |elem|
      @hash[elem] = [count(elem), enum.count(elem)].max
    end
    self
  end
  alias merge union!

  def do_with(enum)
    raise ArgumentError unless enum.is_a?(Enumerable)
    raise ArgumentError unless enum.each.instance_of?(Enumerator)

    return enum.each unless block_given?
    enum.each { |elem| yield elem }
  end
end

class Set < Bag
  def multiplicity(elem)
    @hash[elem] > 0 ? 1 : 0
  end

  def member?(elem)
    multiplicity(elem) == 1
  end
end

enum = [1, 2, 3, 3]
set = Set.new(enum)
bag = Bag.new(enum)

set.each { |elem| puts elem } # output: 1 2 3
bag.each { |elem| puts elem } # output: 1 2 3 3

set.count(3) #=> 1
bag.count(3) #=> 2
