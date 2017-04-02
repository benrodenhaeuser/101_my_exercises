module Enumerable
  def my_inject(initial = nil)
    if initial
      memo = initial
      for elem in self
        memo = yield(memo, elem)
      end
    else
      memo = self.first
      for elem in self.drop(1)
        memo = yield(memo, elem)
      end
    end
  memo
  end
end

p (5..10).my_inject(0) { |memo, n| memo + n } # 45
p (5..10).my_inject { |memo, n| memo + n } # 45
p [5, 6, 7, 8, 9, 10].my_inject(0) { |memo, n| memo + n } # 45
p [5, 6, 7, 8, 9, 10].my_inject() { |memo, n| memo + n } # 45
