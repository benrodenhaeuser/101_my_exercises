# write a method that, given a number n, returns an array with the first n numbers of the Fibonacci series
# using this method, write another method that returns the fibonacci number at index n

def fibo_array(size)

  return [1] if size == 1
  return [1, 1] if size == 2

  fibo_array = [1, 1]
  index = 2

  while fibo_array.size < size
    fibo_array[index] = fibo_array[index - 1] + fibo_array[index - 2]
    index += 1
  end

  fibo_array

end

def fibo(index)
  fibo_array(index).last
end


p fibo_array(1) == [1]
p fibo_array(2) == [1, 1]
p fibo_array(3) == [1, 1, 2]
p fibo_array(4) == [1, 1, 2, 3]
p fibo_array(8) == [1, 1, 2, 3, 5, 8, 13, 21]

p fibo(1) == 1
p fibo(2) == 1
p fibo(3) == 2
p fibo(4) == 3
p fibo(8) == 21
