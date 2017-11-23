def fibonacci(n)
  case n
  when 0 then 0
  when 1 then 1
  else
    fibonacci(n - 1) + fibonacci(n - 2)
  end
end

(1..10).each { |n| puts fibonacci(n) }

def fibo_iterative(n)
  return 0 if n == 0
  return 1 if n == 1

  prev_prev = 0
  prev = 1
  index = 2

  loop do
    fibo = prev_prev + prev
    break fibo if counter == n
    prev_prev = prev
    prev = fibo
    index += 1
  end
end



def fibo_iter(prev_prev, prev, counter)
  fibo = prev_prev + prev
  prev_prev = prev
  prev = fibo
  counter += 1
end
