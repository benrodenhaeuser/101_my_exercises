class ClassicalSet < NumericMap
  include SetLike

  def initialize(enum = [])
    raise ArgumentError unless enum.respond_to?(:each)
    super()
    enum.each { |key| add(key) }
  end

  def add(key, _ = 1)
    self[key] = 1
  end

  def delete(key, _ = 1)
    self[key] = 0
  end

  def valid_value?(val)
    [0, 1].include?(val)
  end

  # (custom methods for this set type)

  def each_elem
    return to_enum(:each_elem) unless block_given?
    each_pair { |elem, _| yield(elem) }
  end

  def to_s
    '{' + map { |key, _| key.to_s }.join(', ') + '}'
  end
end
