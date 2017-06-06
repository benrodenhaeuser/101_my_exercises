# Write a method that returns a list of all substrings of a string. The returned list should be ordered by where in the string the substring begins. This means that all substrings that start at position 0 should come first, then all substrings that start at position 1, and so on. Since multiple substrings will occur at each position, the substrings at a given position should be returned in order from shortest to longest.

=begin
  *Problem:*
  - a substring of a word is a non-empty segment of the string
  - for example 'ben' and 'nja' are both substrings of 'benjamin'
  - want to find *all* substrings of a given word
  - want them sorted by starting index first, and by length second

  substrings of `ben`:
  %w[
    b, be, ben,
    e, en,
    n
  ]

  The problem description seems to imply that we want to keep repetitions
  (e.g. the substrings of 'bebe' will contain 'be' twice)

  *Plan of Attack:*
  - auxiliary method: initial substrings of a string (i.e., substrings starting at 0): should start with smaller ones
  - main method:
    - "loop over the string, calling auxiliary method for appropriate string on every iteration"

  *Pseudo-Code:*

  **Auxiliary method :initial_substrings (given word)**
    init_substrings = []
    for index in range (0...length_of_word):
      append word[0..index] to init_substrings
    return init_substrings

  **Main method :substrings (given word)**
    substrings = []
    for index in range (0...length_of_word):
      append initial_substrings(word[index...length_of_word]) to substrings
    return substrings

=end


def initial_substrings(word)
  (0...word.length).map { |index| word[0..index] }
end

def substrings(word)
  (0...word.length).inject([]) do |memo, index|
    memo + initial_substrings(word[index...word.length])
  end
end

word = ''
p substrings(word)

word = 'b'
p substrings(word)

word = 'ben'
p substrings(word)
