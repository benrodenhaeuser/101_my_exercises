# find the prime numbers up to n using the sieve of erastothenes

# ---------------------------------------------------------------------------
# the basic idea
# ---------------------------------------------------------------------------

def sieve_of_erastothenes(n)
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

p sieve_of_erastothenes(100)

# ---------------------------------------------------------------------------
# a proper solution
# ---------------------------------------------------------------------------
