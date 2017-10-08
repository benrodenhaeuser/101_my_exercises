=begin

The Levenshtein distance is a string metric for measuring the difference between two sequences. Informally, the Levenshtein distance between two words is the minimum number of single-character edits (*insertions*, *deletions* or *substitutions*) required to change one word into the other.

Use the Levenshtein recurrence

=end

# ---------------------------------------------------------------------------
# Recursive solution
# ---------------------------------------------------------------------------

def levensthein_rec(string1, string2)
  lengths = [string1.length, string2.length]
  return lengths.max if lengths.min == 0 # insert N chars

  cost =
    string1[-1] == string2[-1] ? 0 : 1

  [
    levensthein_rec(string1[0...-1], string2) + 1, # delete
    levensthein_rec(string1, string2[0...-1]) + 1, # delete
    levensthein_rec(string1[0...-1], string2[0...-1]) + cost # substitute
  ].min
end

# ---------------------------------------------------------------------------
# Dynamic programming solution
# ---------------------------------------------------------------------------

def levensthein_dyn(string1, string2)
  table = []
  0.upto(string1.length) { |index| table[index] = [] }

  (0..string1.length).each do |row|
    (0..string2.length).each do |col|
      if [row, col].min == 0
        table[row][col] = [row, col].max
      else
        cost = (string1[row - 1] == string2[col - 1]) ? 0 : 1
        table[row][col] =
          [
            table[row - 1][col] + 1,
            table[row][col - 1] + 1,
            table[row - 1][col - 1] + cost
          ].min
      end
    end
  end

  table[string1.length][string2.length]
end

# ---------------------------------------------------------------------------
# Computing the edit sequence
# ---------------------------------------------------------------------------

# todo


# ---------------------------------------------------------------------------
# Tests
# ---------------------------------------------------------------------------

p levensthein_rec('', 'ben') == 3
p levensthein_rec('b', 'ben') == 2
p levensthein_rec('kitten', 'sitting') == 3
p levensthein_rec('body', 'podium') == 4
p levensthein_rec('magnus', 'richel') == 6

p levensthein_dyn('', 'ben') == 3
p levensthein_dyn('b', 'ben') == 2
p levensthein_dyn('kitten', 'sitting') == 3
p levensthein_dyn('body', 'podium') == 4
p levensthein_dyn('magnus', 'richel') == 6
