# find the prime numbers up to n using the sieve of erastothenes

require 'benchmark'

# ---------------------------------------------------------------------------
# basic idea
# ---------------------------------------------------------------------------

def sieve_of_erastothenes1(n)
  primes = (2..n).to_a

  (2..n).each do |number|
    multiples(number, n).each do |multiple|
      primes.delete(multiple)
    end
  end

  primes
end

def multiples(n, upper_bound)
  multiples = []
  number = 2 * n
  while number <= upper_bound
    multiples << number
    number += n
  end
  multiples
end

# ---------------------------------------------------------------------------
# improvement 1
# ---------------------------------------------------------------------------

# don't calculate multiples of numbers that are already deleted

def sieve_of_erastothenes2(n)
  primes = (2..n).to_a

  (2..n).each do |number|
    if primes[number]
      multiples(number, n).each do |multiple|
        primes.delete(multiple)
      end
    end
  end

  primes
end

# ---------------------------------------------------------------------------
# improvement 2
# ---------------------------------------------------------------------------

# deleting from an array is costly, we should index into the array and *flag* as deleted (rather than actually deleting)

def sieve_of_erastothenes3(n)
  primes = (0..n).to_a

  (2..n).each do |number|
    if primes[number]
      multiples(number, n).each do |multiple|
        primes[multiple] = nil
      end
    end
  end

  primes.compact.select { |num| num > 1 }
end

# ---------------------------------------------------------------------------
# prime?
# ---------------------------------------------------------------------------

# test whether the argument given is prime

def prime?(n)
  return false if n < 2

  sieve = (0..n).to_a

  (2..n).each do |number|
    if sieve[number]
      multiples(number, n).each do |multiple|
        sieve[multiple] = nil
      end
    end
  end

  !!sieve[n]
end

# ---------------------------------------------------------------------------
# tests
# ---------------------------------------------------------------------------

# p sieve_of_erastothenes1(100)
# # [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]
#
# p sieve_of_erastothenes1(100) == sieve_of_erastothenes2(100) # true
# p sieve_of_erastothenes2(100) == sieve_of_erastothenes3(100) # true
#
# p sieve_of_erastothenes1(10000) == sieve_of_erastothenes2(10000) # true
# p sieve_of_erastothenes2(10000) == sieve_of_erastothenes3(10000) # true


# ---------------------------------------------------------------------------
# benchmarks
# ---------------------------------------------------------------------------

# puts Benchmark.realtime { sieve_of_erastothenes1(10000) } # 6.221393000334501
# puts Benchmark.realtime { sieve_of_erastothenes2(10000) } # 5.862776000052690
# puts Benchmark.realtime { sieve_of_erastothenes3(10000) } # 0.004113999661058

# note the dramatic speed increase obtained by avoiding the delete operation.
