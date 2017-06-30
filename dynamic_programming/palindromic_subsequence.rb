# given a string s, find a longest palindromic subsequence of s.

# -----------------------------------------------------------------------------
# finding a recurrence
# -----------------------------------------------------------------------------

=begin

given a string s

if s.size < 2:
  lps(s) = s

if string.size >= 2:
  lps(s) = s_0 + lps(s_1..s_n-1) s_n if s_0 = s_n
  lps(s) = max_by_length(lps(s_0..s_n-1), lps(s_1..s_n)) otherwise


=end

# -----------------------------------------------------------------------------
# implementing the recurrence
# -----------------------------------------------------------------------------

def lps(string)
  if string.size <= 1
    string
  elsif string[0] == string[-1]
    string[0] + lps(string[1..-2]) + string[-1]
  else
    [lps(string[0..-2]), lps(string[1..-1])].max_by { |string| string.length }
  end
end

# p lps('') == ''
# p lps('a') == 'a'
# p lps('ab') == 'a'
# p lps('abuioba') == "abuba"
# p lps('abuiobaslgkajsflkasjlfkjaabuiobaabuioba') == "abuibaajflklfjaabiuba"

# -----------------------------------------------------------------------------
# dynamic programming solution: memoization
# -----------------------------------------------------------------------------

def lps_memo(string, palindromes = {})
  return palindromes[string] if palindromes[string]

  if string.size <= 1
    palindromes[string] = string
  elsif string[0] == string[-1]
    palindromes[string] =
      string[0] + lps_memo(string[1..-2], palindromes) + string[-1]
  else
    palindromes[string] =
      [
        lps_memo(string[0..-2], palindromes),
        lps_memo(string[1..-1], palindromes)
      ].max_by { |string| string.length }
  end
end

# p lps_memo('') == ''
# p lps_memo('a') == 'a'
# p lps_memo('ab') == 'a'
# p lps_memo('abuioba') == "abuba"
# p lps_memo('abuiobaslgkajsflkasjlfkjaabuiobaabuioba') == "abuibaajflklfjaabiuba"

# -----------------------------------------------------------------------------
# build table using enumeration of substrings by length
# -----------------------------------------------------------------------------

def substrings(string)
  substrings = ['']
  (1..string.length).each do |length|
    string.chars.each_index do |index|
      if string.slice(index, length).length == length
        substrings << string.slice(index, length)
      end
    end
  end
  substrings
end

def lps_tabu(string)
  table = {}

  substrings(string).each do |string|

    table[string] =
      if string.length <= 1
         string
      elsif string[0] == string[-1]
        string[0] + table[string[1..-2]] + string[-1]
      else
        [
          table[string[0..-2]],
          table[string[1..-1]]
        ].max_by { |string| string.length }
      end

  end

  table[string]
end

p lps_tabu('') == ''
p lps_tabu('a') == 'a'
p lps_tabu('ab') == 'a'
p lps_tabu('abuioba') == "abuba"
p lps_tabu('abuiobaslgkajsflkasjlfkjaabuiobaabuioba') == "abuibaajflklfjaabiuba"

# -----------------------------------------------------------------------------
# with a two-dimensional matrix
# -----------------------------------------------------------------------------
