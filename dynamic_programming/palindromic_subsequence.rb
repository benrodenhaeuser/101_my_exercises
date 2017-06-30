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

# -----------------------------------------------------------------------------
# memoization
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

# -----------------------------------------------------------------------------
# tabulation using enumeration of substrings
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

def lps_substr(string)
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

# -----------------------------------------------------------------------------
# tabulation with a two-dimensional matrix: approach
# -----------------------------------------------------------------------------

=begin

-- given a string s with indices ranging from 0 to n, we build a matrix with
   columns and rows both ranging from 0 to n.
-- a cell matrix[i][j] is to be filled in with the lps of string[i..j]
-- we fill in the matrix diagonal by diagonal.
-- we start by filling in the 0-diagonal, i.e., the cells matrix[i][j] such
   that i is equal to j. for each such cell, the value to be filled in is string[i] (== string[j]).
-- next, we consider the 1-diagonal (i.e. cells matrix[i][j] such that
   j - i == 1). here, the rule is: if the chars match, take the pair, else take the first char. (it would be nice to avoid this, but I don't see how right now)
-- for the remaining diagonals, we do it recursively.
-- we apply the (adapted) recurrence, i.e.

      matrix[i][j] =
        if string[i] == string[j]
          then string[i] + matrix[i-1][j+1] + string[j]
        else
          [matrix[i - 1][j], matrix[i][j+1]].max_by_length

=end

# -----------------------------------------------------------------------------
# tabulation with a two-dimensional matrix: implementation
# -----------------------------------------------------------------------------

def lps_matrix(string)
  return '' if string == ''

  matrix = Array.new(string.size, nil)
  matrix.each_index { |index| matrix[index] = Array.new(string.size, nil)}

  # 0-diagonal
  (0..string.size - 1).each do |row_idx|
    col_idx = row_idx
    matrix[row_idx][col_idx] = string[row_idx]
  end

  # other diagonals (1-diagonal to (size - 1)-diagonal)
  (1..string.size - 1).each do |diag|
    (0..string.size - (diag + 1)).each do |row_idx|
      col_idx = row_idx + diag
      matrix[row_idx][col_idx] =
        if string[row_idx] == string[col_idx]
          string[row_idx] + (matrix[row_idx + 1][col_idx - 1]).to_s + string[col_idx]
        else
          [
            matrix[row_idx][col_idx - 1],
            matrix[row_idx + 1][col_idx]
          ].max_by { |string| string.length }
        end
    end

  end

  matrix[0][string.size - 1]

end

# -----------------------------------------------------------------------------
# tests
# -----------------------------------------------------------------------------

# p lps('') == ''
# p lps('a') == 'a'
# p lps('ab') == 'a'
# p lps('abuioba') == "abuba"
# p lps('abuiobaslgkajsflkasjlfkjaabuiobaabuioba') == "abuibaajflklfjaabiuba"

# p lps_memo('') == ''
# p lps_memo('a') == 'a'
# p lps_memo('ab') == 'a'
# p lps_memo('abuioba') == "abuba"
# p lps_memo('abuiobaslgkajsflkasjlfkjaabuiobaabuioba') == "abuibaajflklfjaabiuba"

# p lps_substr('') == ''
# p lps_substr('a') == 'a'
# p lps_substr('ab') == 'a'
# p lps_substr('abuioba') == "abuba"
# p lps_substr('abuiobaslgkajsflkasjlfkjaabuiobaabuioba') == "abuibaajflklfjaabiuba"

p lps_matrix('') == ''
p lps_matrix('a') == 'a'
p lps_matrix('ab') == 'a'
p lps_matrix('abuioba') == "abuba"
p lps_matrix('abuiobaslgkajsflkasjlfkjaabuiobaabuioba') == "abuibaajflklfjaabiuba"
