# sum up the numbers from 1 to n

def sum(n)
  sum = 0
  for i in (1..n)
    sum = sum + i
  end
  sum
end

def sum2(n)
  sum = 0
  (1..n).each { |number| sum += number }
  sum
end

def sum3(n)
  (1..n).inject(0, :+)
end

def Gauss_sum(n)
  (n * (n + 1)) / 2
end


def check(number)
p sum(number) == sum2(number)
p sum2(number) == sum3(number)
p sum3(number) == Gauss_sum(number)
end

check(0)
check(1)
check(10)
check(50)
