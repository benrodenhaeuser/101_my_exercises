=begin

The Levenshtein distance is a string metric for measuring the difference between two sequences. Informally, the Levenshtein distance between two words is the minimum number of single-character edits (*insertions*, *deletions* or *substitutions*) required to change one word into the other.

See https://en.wikipedia.org/wiki/Levenshtein_distance for a definition of the Levensthein recurrence.

=end

# ---------------------------------------------------------------------------
# Edit distance – Recursive solution
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
# Edit distance - Dynamic programming solution
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

  table
  # table[string1.length][string2.length]
end

# ---------------------------------------------------------------------------
# Edit sequence - Based on Dynamic Programming Solution
# ---------------------------------------------------------------------------

# idea: store a character ("current edit") along with the number

def levensthein_edit(source, target)
  table = []
  0.upto(source.length) { |index| table[index] = [] }

  (0..source.length).each do |row|
    (0..target.length).each do |col|
      if row == 0 && col > 0
        table[row][col] = [col, target[col - 1]]
      elsif col == 0
        table[row][col] = [row, '']
      else
        cost = (source[row - 1] == target[col - 1]) ? 0 : 1
        table[row][col] =
          [
            [table[row - 1][col].first + 1, ''],
            [table[row][col - 1].first + 1, target[col - 1]],
            [table[row - 1][col - 1].first + cost, target[col - 1]]
          ].min_by { |entry| entry.first }
      end
    end
  end

  # table[source.length][target.length]
  table
end

# idea: "backtrace" – we need to record where we came from, in each cell. this will allow us to jump back.
# we start from the bottom-right corner, because that's where the optimal score is.
# this allows us to produce a string in reverse order.


# ---------------------------------------------------------------------------
# Edit sequence - BACKTRACE
# ---------------------------------------------------------------------------

=begin

- Assume we have stored pointers (up, left, diag) with each cell.
- How to produce the edit sequence?

- Initialize edits to an empty array, push target to edits.
- Initialize current cell to bottom-right corner

- Until current cell is cell [0,0]:
  - if current cell has :left
      push to edits:
        the last element of edits with character at index 'last char of target row' deleted
      reassign current cell to:
        left-adjacent cell

  - if current cell is :up
      push to edits:
        the last element of edits with last char of source row inserted at index 'first char of source row'
      reassign current cell to:
        upwards-adjacent cell

  - if current pointer is :diag
      push to edits:
        the last element of edits with char at index x replaced by last char of source


Now how to we know the value of x in each case?

Perhaps if we produced an alignment first? Then it would seem to be pretty easy to derive an edit sequence, because we can proceed in a character by character fashion very easily

=end



# via alignment? what would an alignment look like? basically two arrays that show how the chars are mapped. This is nice insofar as we can then edit from source to target


# ---------------------------------------------------------------------------
# Tests
# ---------------------------------------------------------------------------

# p levensthein_rec('', 'ben') == 3
# p levensthein_rec('b', 'ben') == 2
# p levensthein_rec('kitten', 'sitting') == 3
# p levensthein_rec('body', 'podium') == 4
# p levensthein_rec('magnus', 'richel') == 6

# p levensthein_dyn('', 'ben') #== 3
# p levensthein_dyn('b', 'ben') #== 2
# p levensthein_dyn('kitten', 'sitting') #== 3
# p levensthein_dyn('body', 'podium') #== 4
# p levensthein_dyn('magnus', 'richel') #== 6

# p levensthein_edit('', 'ben')
table = levensthein_edit('kitten', 'sitting') #== 3
table.each { |row| p row}

# ---------------------------------------------------------------------------
# Applications
# ---------------------------------------------------------------------------

=begin

- find matches for a given string in a text with Levensthein distance up to x.
- spell-checking, optical character recognition

=end
