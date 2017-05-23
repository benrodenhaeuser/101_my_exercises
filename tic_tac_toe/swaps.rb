require 'benchmark'

=begin

7 symmetries:
- 90 degree rotation (cols reversed become rows)
- 180 degree rotation (reverse array)
- 270 degree rotation
- reflection across the main diagonal (cols become rows)
- reflection across the secondary diagonal
- reflection across the horizontal (swap slices)
- reflection across the vertical (reverse slices)

... so evaluating one position, we get 7 more for free.

=end

LINE_LENGTH = 3

# states represent square matrices (ttt boards) of size LINE_LENGTH

def column(state, index)
  state.each_slice(LINE_LENGTH).map { |slice| slice[index] }
end

# rotation by 90 degrees
def rotate90(state)
  (0...LINE_LENGTH).flat_map { |index| column(state, index).reverse }
end

# rotation by 180 degrees
def rotate180(state)
  state.reverse
end

# rotation by 270 degrees
def rotate270(state)
  (LINE_LENGTH - 1).downto(0).flat_map { |index| column(state, index) }
end

# reflection across main diagonal
def transpose(state)
  (0...LINE_LENGTH).flat_map { |index| column(state, index) }
end

# reflection across secondary diagonal
def reflect_sec_diag(state)
  (LINE_LENGTH - 1).downto(0).flat_map { |index| column(state, index).reverse }
end

# reflection across the horizontal
def reflect_horizontal(state)
  state.each_slice(LINE_LENGTH).reverse_each.to_a.flatten
end

# reflection across the vertical
def reflect_vertical(state)
  state.each_slice(LINE_LENGTH).flat_map { |slice| slice.reverse }
end

state = [0, 1, 2, 3, 4, 5, 6, 7, 8]
# p reflect_horizontal(state)
# p reflect_vertical(state)
# p rotate90(state)
p reflect_sec_diag(state)
# [8, 5, 2, 7, 4, 1, 6, 3, 0]
