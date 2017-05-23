require 'benchmark'

=begin

symmetries:
- reflection across the main diagonal (cols become rows)
- 180 degree rotation (reverse array)
- reflection across the horizontal (swap slices)
- reflection across the vertical (reverse slices)
- 90 degree rotation (cols reversed become rows)
- 270 degree rotation
- reflection across the secondary diagonal

=end


LINE_LENGTH = 3

def rotate180(state)
  state.reverse
end

# states represent square matrices (ttt boards) of size LINE_LENGTH

def column(state, index)
  state.each_slice(LINE_LENGTH).map { |slice| slice[index] }
end

# I. reflection across main diagonal
def transpose(state)
  (0...LINE_LENGTH).flat_map { |index| column(state, index) }
end

# II. rotation by 180 degrees
def rotate180(state)
  state.reverse
end

# III. reflection across the horizontal
def reflect_horizontal(state)
  state.each_slice(LINE_LENGTH).reverse_each.to_a.flatten
end

# IV. reflection across the vertical
def reflect_vertical(state)
  state.each_slice(LINE_LENGTH).map { |slice| slice.reverse }.flatten
end

# V. rotation by 90 degrees
def rotate90(state)
  (0...LINE_LENGTH).flat_map { |index| column(state, index).reverse }
end

# VI. rotation by 270 degrees
def rotate270(state)
  rotate90(rotate180(state))
end

# VII. reflection across the secondary diagonal
def reflect_sec_diag(state)
  reflect_horizontal(rotate90(state))
end


state = [0, 1, 2, 3, 4, 5, 6, 7, 8]
p reflect_horizontal(state)
p reflect_vertical(state)
p rotate90(state)
