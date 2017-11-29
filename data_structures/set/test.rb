class Collection
  include Enumerable

  def initialize
    @hash = Hash.new
  end

  # we can do this:
  def [](item, value)
    @hash[item] = value
  end

  # but not this:
  def count=(item, value)
    @hash[item] = value
  end
end

coll = Collection.new
coll[:a] = 2 # fine
coll.count(:a) = 3 # not fine (syntax error)
