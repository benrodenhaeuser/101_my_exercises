
require "enumerator"
require "multimap"


class Multiset
  VERSION = "0.5.3"

  include Enumerable

  def initialize(list = nil)
    @entries = {} # hash
    if list.kind_of?(Enumerable)
      list.each{ |item| add item }
    elsif list != nil
      raise ArgumentError, "Item list must be an instance including 'Enumerable' module"
    end
  end

  def Multiset.[](*list)
    Multiset.new(list)
  end

  def Multiset.parse(object)
    if object.kind_of?(String)
      raise ArgumentError, "Multiset.parse can not parse strings. If you would like to store string lines to a multiset, use Multiset.from_lines(string)."
    end

    if object.instance_of?(Multiset)
      ret = object.dup
    else
      ret = Multiset.new
      if defined? object.each_pair
        object.each_pair{ |item, count| ret.add item, count }
      elsif object.kind_of?(Enumerable)
        object.each{ |item| ret.add item }
      else
        raise ArgumentError, "Source of Multiset must have 'each_pair' method or include 'Enumerable' module"
      end
    end
    ret
  end

  def Multiset.from_lines(str)
    Multiset.new(str.enum_for(:each_line))
  end

  def Multiset.parse_force(object)
    if object.kind_of?(String)
      Multiset.from_lines(object)
    else
      Multiset.parse(object)
    end
  end

  def dup
    @entries.to_multiset
  end

  def to_hash
    @entries.dup
  end

  def to_set
    require "set"
    Set.new(@entries.keys)
  end

  def to_a
    ret = []
    @entries.each_pair do |item, count|
      ret.concat Array.new(count, item)
    end
    ret
  end

  def hash # :nodoc:
    val = 0
    @entries.each_pair do |item, count|
      val += item.hash * count
    end
    val
  end

  def eql?(other) # :nodoc:
    if self.hash == other.hash
      self == other
    else
      false
    end
  end

  def replace(other)
    @entries.clear
    other.each_pair do |item, count|
      self.renew_count(item, count)
    end
    self
  end

  def size
    @entries.inject(0){ |sum, item| sum += item[1] }
  end
  alias length size

  def empty?
    @entries.empty?
  end

  def items
    @entries.keys
  end

  def clear
    @entries.clear
    self
  end

  def include?(item)
    @entries.has_key?(item)
  end
  alias member? include?

  def listing(delim = "\n")
    buf = ''
    init = true
    self.each do |item|
      if init
        init = false
      else
        buf += delim
      end
      buf += block_given? ? yield(item).to_s : item.inspect
    end
    buf
  end

  def to_s(delim = "\n")
    buf = ''
    init = true
    @entries.each_pair do |item, count|
      if init
        init = false
      else
        buf += delim
      end
      item_tmp = block_given? ? yield(item) : item.inspect
      buf += "\##{count} #{item_tmp}"
    end
    buf
  end

  def inspect # :nodoc:
    buf = "#<Multiset:"
    buf += self.to_s(', ')
    buf += '>'
    buf
  end

  def count(*item_list)
    if block_given?
      unless item_list.empty?
        raise ArgumentError, "Both item and block cannot be given"
      end

      result = 0
      @entries.each_pair do |i, c|
        result += c if yield(i)
      end
      result
    else
      case item_list.size
      when 0
        self.size
      when 1
        @entries.has_key?(item_list.first) ? @entries[item_list.first] : 0
      else
        raise ArgumentError, "Only one item can be given"
      end
    end
  end

  def renew_count(item, number)
    return nil if number == nil
    n = number.to_i
    if n > 0
      @entries[item] = n
    else
      @entries.delete(item)
    end
    self
  end

  def add(item, addcount = 1)
    return nil if addcount == nil
    a = addcount.to_i
    return nil if a <= 0
    self.renew_count(item, self.count(item) + a)
  end
  alias << add

  def delete(item, delcount = 1)
    return nil if delcount == nil || !self.include?(item)
    d = delcount.to_i
    return nil if d <= 0
    self.renew_count(item, self.count(item) - d)
  end

  def delete_all(item)
    @entries.delete(item)
    self
  end

  def compare_set_with(other) # :nodoc: :yields: number_in_self, number_in_other
    (self.items | other.items).each do |item|
      return false unless yield(self.count(item), other.count(item))
    end
    true
  end

  def superset?(other)
    unless other.instance_of?(Multiset)
      raise ArgumentError, "Argument must be a Multiset"
    end
    compare_set_with(other){ |s, o| s >= o }
  end

  def proper_superset?(other)
    unless other.instance_of?(Multiset)
      raise ArgumentError, "Argument must be a Multiset"
    end
    self.superset?(other) && self != other
  end

  def subset?(other)
    unless other.instance_of?(Multiset)
      raise ArgumentError, "Argument must be a Multiset"
    end
    compare_set_with(other){ |s, o| s <= o }
  end

  def proper_subset?(other)
    unless other.instance_of?(Multiset)
      raise ArgumentError, "Argument must be a Multiset"
    end
    self.subset?(other) && self != other
  end

  def ==(other)
    return false unless other.instance_of?(Multiset)
    compare_set_with(other){ |s, o| s == o }
  end

  def merge(other)
    ret = self.dup
    other.each_pair do |item, count|
      ret.add(item, count)
    end
    ret
  end
  alias + merge

  def merge!(other)
    other.each_pair do |item, count|
      self.add(item, count)
    end
    self
  end

  def subtract(other)
    ret = self.dup
    other.each_pair do |item, count|
      ret.delete(item, count)
    end
    ret
  end
  alias - subtract

  def subtract!(other)
    other.each_pair do |item, count|
      self.delete(item, count)
    end
    self
  end

  def &(other)
    ret = Multiset.new
    (self.items & other.items).each do |item|
      ret.renew_count(item, [self.count(item), other.count(item)].min)
    end
    ret
  end

  def |(other)
    ret = self.dup
    other.each_pair do |item, count|
      ret.renew_count(item, [self.count(item), count].max)
    end
    ret
  end

  def each
    if block_given?
      @entries.each_pair do |item, count|
        count.times{ yield item }
      end
      self
    else
      Enumerator.new(self, :each)
    end
  end

  def each_item(&block) # :yields: item
    if block
      @entries.each_key(&block)
      self
    else
      @entries.each_key
    end
  end

  def each_with_count(&block) # :yields: item, count
    if block
      @entries.each_pair(&block)
      self
    else
      @entries.each_pair
    end
  end
  alias :each_pair :each_with_count

  def map # :yields: item
    ret = Multiset.new
    @entries.each_pair do |item, count|
      ret.add(yield(item), count)
    end
    ret
  end
  alias collect map

  def map!(&block) # :yields: item
    self.replace(self.map(&block))
    self
  end
  alias collect! map!

  def map_with
    ret = Multiset.new
    @entries.each_pair do |item, count|
      val = yield(item, count)
      ret.add(val[0], val[1])
    end
    ret
  end
  alias collect_with map_with

  def map_with!
    self.to_hash.each_pair do |item, count|
      self.delete(item, count)
      val = yield(item, count)
      self.add(val[0], val[1])
    end
    self
  end
  alias collect_with! map_with!

  def sample
    return nil if empty?
    pos = Kernel.rand(self.size)
    @entries.each_pair do |item, count|
      pos -= count
      return item if pos < 0
    end
  end
  alias :rand :sample

  def flatten
    ret = Multiset.new
    self.each do |item|
      if item.kind_of?(Multiset)
        ret += item.flatten
      else
        ret << item
      end
    end
    ret
  end

  def flatten!
    ret = nil
    self.to_a.each do |item|
      if item.kind_of?(Multiset)
        self.delete(item)
        self.merge!(item.flatten)
        ret = self
      end
    end
    ret
  end

  def reject
    ret = Multiset.new
    @entries.each_pair do |item, count|
      ret.renew_count(item, count) unless yield(item)
    end
    ret
  end

  def reject_with
    ret = Multiset.new
    @entries.each_pair do |item, count|
      ret.renew_count(item, count) unless yield(item, count)
    end
    ret
  end

  def reject!
    ret = nil
    @entries.each_pair do |item, count|
      if yield(item)
        self.delete_all(item)
        ret = self
      end
    end
    ret
  end

  def delete_if
    @entries.each_pair do |item, count|
      self.delete_all(item) if yield(item)
    end
    self
  end

  def delete_with
    @entries.each_pair do |item, count|
      @entries.delete(item) if yield(item, count)
    end
    self
  end

  def group_by
    ret = Multimap.new
    @entries.each_pair do |item, count|
      ret[yield(item)].add(item, count)
    end
    ret
  end
  alias :classify :group_by

  def group_by_with
    ret = Multimap.new
    @entries.each_pair do |item, count|
      ret[yield(item, count)].add(item, count)
    end
    ret
  end
  alias :classify_with :group_by_with

  def find(ifnone = nil, &block) # :yields: item
    if block
      find_(ifnone, &block)
    else
      self.to_enum(:find_, ifnone)
    end
  end
  alias :detect :find

  def find_(ifnone, &block) # :nodoc:
    @entries.each_pair do |item, count|
      return item if yield(item)
    end
    (ifnone == nil) ? nil : ifnone.call
  end
  private :find_

  def find_with(ifnone = nil, &block) # :yields: item, count
    if block
      find_with_(ifnone, &block)
    else
      self.to_enum(:find_with_, ifnone)
    end
  end
  alias :detect_with :find_with

  def find_with_(ifnone, &block) # :nodoc:
    @entries.each_pair do |item, count|
      return item if yield(item, count)
    end
    (ifnone == nil) ? nil : ifnone.call
  end
  private :find_with_

  def find_all(&block) # :yields: item
    if block
      find_all_(&block)
    else
      self.to_enum(:find_all_, ifnone)
    end
  end
  alias :select :find_all

  def find_all_(&block) # :nodoc:
    ret = Multiset.new
    @entries.each_pair do |item, count|
      ret.renew_count(item, count) if yield(item)
    end
    ret
  end
  private :find_all_

  def find_all_with(&block) # :yields: item, count
    if block
      find_all_with_(&block)
    else
      self.to_enum(:find_all_with_, ifnone)
    end
  end
  alias :select_with :find_all_with

  def find_all_with_(&block) # :nodoc:
    ret = Multiset.new
    @entries.each_pair do |item, count|
      ret.renew_count(item, count) if yield(item, count)
    end
    ret
  end
  private :find_all_with_

  def grep(pattern)
    ret = Multiset.new
    @entries.each_pair do |item, count|
      if pattern === item
        ret.add((block_given? ? yield(item) : item), count)
      end
    end
    ret
  end

  def inject_with(init)
    @entries.each_pair do |item, count|
      init = yield(init, item, count)
    end
    init
  end

  def max(&block) # :yields: a, b
    @entries.keys.max(&block)
  end

  def min(&block) # :yields: a, b
    @entries.keys.min(&block)
  end

  def minmax(&block) # :yields: a, b
    @entries.keys.minmax(&block)
  end

  def max_by(&block) # :yields: item
    @entries.keys.max_by(&block)
  end

  def min_by(&block) # :yields: item
    @entries.keys.min_by(&block)
  end

  def minmax_by(&block) # :yields: item
    @entries.keys.minmax_by(&block)
  end

  def max_with # :yields: item1, count1, item2, count2
    tmp = @entries.each_pair.max{ |a, b| yield(a[0], a[1], b[0], b[1]) }
    tmp ? tmp[0] : nil
  end

  def min_with # :yields: item1, count1, item2, count2
    tmp = @entries.each_pair.min{ |a, b| yield(a[0], a[1], b[0], b[1]) }
    tmp ? tmp[0] : nil
  end

  def minmax_with # :yields: item1, count1, item2, count2
    tmp = @entries.each_pair.minmax{ |a, b| yield(a[0], a[1], b[0], b[1]) }
    tmp ? [tmp[0][0], tmp[1][0]] : nil
  end

  def max_by_with(&block) # :yields: item, count
    tmp = @entries.each_pair.max_by(&block)
    tmp ? tmp[0] : nil # if @entries is not empty, tmp must be a two-element array
  end

  def min_by_with(&block) # :yields: item, count
    tmp = @entries.each_pair.min_by(&block)
    tmp ? tmp[0] : nil # if @entries is not empty, tmp must be a two-element array
  end

  def minmax_by_with(&block) # :yields: item, count
    tmp = @entries.each_pair.minmax_by(&block)
    tmp[0] ? [tmp[0][0], tmp[1][0]] : nil
  end

  def sort(&block) # :yields: a, b
    ret = []
    @entries.keys.sort(&block).each do |item|
      ret.fill(item, ret.length, @entries[item])
    end
    ret
  end

  def sort_by(&block) # :yields: item
    ret = []
    @entries.keys.sort_by(&block).each do |item|
      ret.fill(item, ret.length, @entries[item])
    end
    ret
  end

  def sort_with # :yields: item1, count1, item2, count2
    ret = []
    @entries.each_pair.sort{ |a, b| yield(a[0], a[1], b[0], b[1]) }.each do |item_count|
      ret.fill(item_count[0], ret.length, item_count[1])
    end
    ret
  end

  def sort_by_with # :yields: item1, count1, item2, count2
    ret = []
    @entries.each_pair.sort_by{ |a| yield(*a) }.each do |item_count|
      ret.fill(item_count[0], ret.length, item_count[1])
    end
    ret
  end
end

class Hash
  def to_multiset
    ret = Multiset.new
    self.each_pair{ |item, count| ret.renew_count(item, count) }
    ret
  end
end

if __FILE__ == $0
  puts 'Creating multisets'
  a = {1=>5, 4=>2, 6=>0}.to_multiset
  b = Multiset[1,1,4,4,6,6]
  p a
  p b

  puts 'Operations for multisets'
  p a + b
  p a - b
  p a & b
  p a | b

  puts 'Modifying multisets'
  p a.reject!{ |item| item == 3 }
  p a
  p a.reject!{ |item| item == 4 }
  p a
  a.add(3)
  a.add(4, 10)
  a << 1
  p a

  puts 'Flattening multisets'
  a = Multiset[6,6,3,4,Multiset[5,8],Multiset[6,Multiset[3,8],8],8]
  p a
  p a.flatten!
  p a.flatten!
end
