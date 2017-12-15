require_relative 'generic_set'

class FuzzySet < GenericSet
  def initialize
    super(Numeric, 0, 1)
  end
end
