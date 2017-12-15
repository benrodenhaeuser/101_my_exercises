class ClassicalSet < GenericSet
  def initialize
    super(Integer, 0, 1)
  end

  def to_s
    '{' + each_elem.map(&:to_s).join(', ') + '}'
  end

  def inspect
    "#<#{self.class}: {" + each_elem.map(&:inspect).join(', ') + '}>'
  end
end
