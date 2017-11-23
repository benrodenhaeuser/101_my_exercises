module TailRecursion

  ##
  # sum up to n

  # reference point
  def self.sum_head(n)
    if n == 1
      1
    else
      n + sum(n - 1)
    end
  end

  def self.sum_tail(n, acc)
    if n == 0
      acc
    else
      sum_tail(n - 1, acc + n)
    end
  end

  def self.sum(n)
    sum_tail(n, 0)
  end

  #
  # factorial of n

  # reference point
  def self.factorial_head(n)
    if n == 1
      1
    else
      n * factorial_head(n - 1)
    end
  end

  def self.factorial_tail(n, acc)
    if n == 1
      acc
    else
      factorial_tail(n - 1, acc * n)
    end
  end

  def self.factorial(n)
    factorial_tail(n, 1)
  end

  #
  # nth number in fibonacci series

  # reference point
  def self.fibonacci_head(n)
    case n
    when 0 then 0
    when 1 then 1
    else
      fibonacci_head(n - 1) + fibonacci_head(n - 2)
    end
  end

  def self.fibonacci_tail(n, acc1, acc2)
    if n == 0
      acc1
    elsif n == 1
      acc2
    else
      acc1, acc2 = acc2, acc1 + acc2
      fibonacci_tail(n - 1, acc1, acc2)
    end
  end

  def self.fibonacci(n)
    fibonacci_tail(n, 0, 1)
  end
end

# difference between head and tail recursion:
# in tail recursion, the return value of the recursive call is the return value
# of the current call. so we can throw away the frame for the current call on
# the runtime stack – we will no longer need it to determine the current return
# value! ==> key insight that enables tail call optimization.
