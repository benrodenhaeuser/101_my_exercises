require 'benchmark'

=begin
- A tic tac toe board is a n x n matrix.
- We represent it as a n^2 length array.

there are 7 symmetries:
- 90 degree rotation (cols reversed become rows)
- 180 degree rotation (reverse array)
- 270 degree rotation
- reflection across the main diagonal (cols become rows)
- reflection across the secondary diagonal
- reflection across the horizontal (swap slices)
- reflection across the vertical (reverse slices)

symmetric boards are strategically equivalent.

=end

LENGTH = 3

# rotation by 90 degrees
def rotate90(state)
  state.each_slice(LENGTH).reverse_each.to_a.transpose.flatten
end

# rotation by 180 degrees
def rotate180(state)
  state.reverse
end

# rotation by 270 degrees
def rotate270(state)
  rotate90(rotate180(state))
end

# reflection across the main diagonal
def transpose(state)
  state.each_slice(LENGTH).to_a.transpose.flatten
end

# reflection across the counter diagonal
def reflect_sec_diag(state)
  transpose(rotate180(state))
end

# reflection across the horizontal
def reflect_horizontal(state)
  state.each_slice(LENGTH).reverse_each.to_a.flatten
end

# reflection across the vertical
def reflect_vertical(state)
  state.each_slice(LENGTH).flat_map(&:reverse)
end

# tests and benchmarks

state = [0, 1, 2, 3, 4, 5, 6, 7, 8]

p rotate90(state) == [6, 3, 0, 7, 4, 1, 8, 5, 2] # true
p rotate180(state) == [8, 7, 6, 5, 4, 3, 2, 1, 0] # true
p rotate270(state) == [2, 5, 8, 1, 4, 7, 0, 3, 6] # true
p transpose(state) == [0, 3, 6, 1, 4, 7, 2, 5, 8] # true
p reflect_sec_diag(state) == [8, 5, 2, 7, 4, 1, 6, 3, 0] # true
p reflect_horizontal(state) == [6, 7, 8, 3, 4, 5, 0, 1, 2] # true
p reflect_vertical(state) == [2, 1, 0, 5, 4, 3, 8, 7, 6] # true

Benchmark.bmbm do |x|
  x.report("rot90") { rotate90(state) }
  x.report("rot180") { rotate180(state) } # fast!
  x.report("rot270") { rotate270(state) } # slow!
  x.report("trans") { transpose(state) }
  x.report("sec_dg") { reflect_sec_diag(state) } # slow!
  x.report("horiz") { reflect_horizontal(state) }
  x.report("vert") { reflect_vertical(state) }
end

#              user     system      total        real
# rot90    0.000000   0.000000   0.000000 (  0.000021)
# rot180   0.000000   0.000000   0.000000 (  0.000006)
# rot270   0.000000   0.000000   0.000000 (  0.000024)
# trans    0.000000   0.000000   0.000000 (  0.000018)
# sec_dg   0.000000   0.000000   0.000000 (  0.000019)
# horiz    0.000000   0.000000   0.000000 (  0.000016)
# vert     0.000000   0.000000   0.000000 (  0.000017)
