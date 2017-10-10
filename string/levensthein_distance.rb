=begin

The Levenshtein distance is a string metric for measuring the difference between two sequences. Informally, the Levenshtein distance between two words is the minimum number of single-character edits (*insertions*, *deletions* or *substitutions*) required to change one word into the other.

See https://en.wikipedia.org/wiki/Levenshtein_distance for a definition of the Levensthein recurrence.

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
            table[row - 1][col] + 1, # delete
            table[row][col - 1] + 1, # insert (?)
            table[row - 1][col - 1] + cost # substitute
          ].min
      end
    end
  end

  table[string1.length][string2.length]
end

# ---------------------------------------------------------------------------
# Transform string1 into string2 (first attempt)
# ---------------------------------------------------------------------------

=begin

- record for each position of the string, what happens there?
- however, what about insertions (string grows)? – from "bat" to "boat"

=end

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

edits = []
levensthein_edit('', 'ben', edits)
p edits

edits = []
levensthein_edit('ben', '', edits)
p edits

edits = []
p levensthein_edit('kitten', 'sitting', edits) == 3
p edits


# ---------------------------------------------------------------------------
# Applications
# ---------------------------------------------------------------------------

=begin

- find matches for a given string in a text with Levensthein distance up to x.
- spell-checking, optical character recognition

=end
