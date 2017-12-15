require_relative 'generic_set'

class MultiSet < GenericSet
  def initialize
    super(Integer, 0, Float::INFINITY)
  end
end
