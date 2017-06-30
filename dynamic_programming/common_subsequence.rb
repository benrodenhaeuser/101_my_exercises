# problem: given two strings s and s', find the longest common subsequence of s
# and s' using dynamic programming.

# -----------------------------------------------------------------------------
# background
# -----------------------------------------------------------------------------

=begin

definition: given a string s, a string s' is a subsequence of s if there is an
order-embedding f from s-indices to s'-indices such that
s[i] = x => s'[f(i)] = x.

an order-embedding is a function f such that for any i, j in the domain of f:
i <= j iff f(i) <= f(j)

Note that order-embeddings are always injective. Notice also that subsequences
are not the same as a substrings!

Example:
`bde` is a subsequence of `abcde`.

=end

# -----------------------------------------------------------------------------
# finding a recurrence
# -----------------------------------------------------------------------------

=begin

express lcs(s, s') in terms of subproblems:
decompose the strings from the right.
there are two options:
- the last two chars match, or they don't.
- in the first case:
      lcs(s, s') = lcs(s[0..-2], s'[0..-2]) + s[-1]
= in the second case: lcs(s, s') is the maxium of
      [lcs(s[0..-2], s'), lcs(s, s'[0..-2])]
so that's the recurrence.

what's the base case? "if one of the strings is empty, then the lcs is empty."

=end

# -----------------------------------------------------------------------------
# implementing the recurrence
# -----------------------------------------------------------------------------

def lcs(string, other_string)
  if string.length == 0 || other_string.length == 0
    ''
  elsif string[-1] == other_string[-1]
    lcs(string[0..-2], other_string[0..-2]) + string[-1]
  else
    [
      lcs(string[0..-2], other_string),
      lcs(string, other_string[0..-2])
    ].max
  end
end

# -----------------------------------------------------------------------------
# dynamic programming solution
# -----------------------------------------------------------------------------

BLANK = ' '

def lcs_dp(string, other_string)

  string = BLANK + string
  other_string = BLANK + other_string
  lcs = Array.new(string.size, [])
  (0...string.length).each { |index| lcs[index][0] = BLANK }
  (0...other_string.length).each { |index| lcs[0][index] = BLANK }

  (1...string.length).each do |index|
    (1...other_string.length).each do |other_index|

      lcs[index][other_index] =
        if string[index] == other_string[other_index]
          lcs[index - 1][other_index - 1] + string[index] # ↖
        else
          [lcs[index - 1][other_index], lcs[index][other_index - 1]].max_by { |string| string.length } # ↑ or ←
        end
    end
  end

  lcs[string.size - 1][other_string.size - 1].lstrip # lstrip removes blank

end

# -----------------------------------------------------------------------------
# tests
# -----------------------------------------------------------------------------

# "naive" solution:

# p lcs('', '') == ''
# p lcs('', 'a') == ''
# p lcs('a', 'b') == ''
# p lcs('a', 'a') == 'a'
# p lcs('abcxuuuux', 'ux') == 'ux'
# p lcs('kabcde', 'bkadcde') == 'kacde'

# dynamic programming solution:

p lcs_dp('', '') == ''
p lcs_dp('', 'a') == ''
p lcs_dp('a', 'b') == ''
p lcs_dp('a', 'a') == 'a'
p lcs_dp('ab', 'ab') == 'ab'
p lcs_dp('abcxuuuux', 'ux') == 'ux'
p lcs_dp('kabcde', 'bkadcde') == 'kacde'
