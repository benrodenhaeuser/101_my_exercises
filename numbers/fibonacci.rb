# write a method that returns the nth Fibonacci number, given n

# ---------------------------------------------------------------------------
# naive recursive solution
# ---------------------------------------------------------------------------

def fibo1(n)
  return 0 if n == 0
  return 1 if n == 1
  fibo1(n - 1) + fibo1(n - 2)
end

# ---------------------------------------------------------------------------
# iterative solution, with an array to store Fibo numbers up to n
# ---------------------------------------------------------------------------

def fibo2(n)
  f = []
  f[0] = 0
  f[1] = 1

  i = 2

  while i <= n
    f[i] = f[i - 1] + f[i - 2]
    i +=1
  end

  f[n]
end

# ---------------------------------------------------------------------------
# like the preceding solution, but array in a separate method
# ---------------------------------------------------------------------------

def fibo_array(n)
  f = []
  f[0] = 0
  f[1] = 1

  2.upto(n) { |i| f[i] = f[i - 1] + f[i - 2] }

  f
end

def fibo3(n)
  fibo_array(n)[n]
end

# ---------------------------------------------------------------------------
# iterative solution, without array
# ---------------------------------------------------------------------------

def fibo4(n)
  return 0 if n == 0
  return 1 if n == 1

  minus2 = 0
  minus1 = 1
  index = 2

  loop do
    fibo = minus1 + minus2
    break fibo if counter == n
    minus2 = minus1
    minus1 = fibo
    index += 1
  end
end

# ---------------------------------------------------------------------------
# tests
# ---------------------------------------------------------------------------

p fibo1(1) # 1
p fibo1(2) # 1
p fibo1(3) # 2
p fibo1(10) # 55

puts

p fibo2(1) # 1
p fibo2(2) # 1
p fibo2(3) # 2
p fibo2(10) # 55

puts

p fibo3(1) # 1
p fibo3(2) # 1
p fibo3(3) # 2
p fibo3(10) # 55

puts

p fibo4(1) # 1
p fibo4(2) # 1
p fibo4(3) # 2
p fibo4(10) # 55
