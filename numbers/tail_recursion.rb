def sum_head(n)
  return 1 if n == 1
  n + sum(n - 1)
end

def sum_tail(n, acc)
  if n == 0
    acc
  else
    sum_tail(n - 1, acc + n)
  end
end

def sum(n)
  sum_tail(n, 0)
end

1.upto(1000) { p sum_head(1000) == sum(1000) }
