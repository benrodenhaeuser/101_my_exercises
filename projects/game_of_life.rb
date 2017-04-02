# GAME OF LIFE

# examples of seeds (source: https://bitstorm.org/gameoflife/)
GLIDER = [
  [false, true, false],
  [false, false, true],
  [true, true, true]
]

SMALL_EXPLODER = [
  [false, true, false],
  [true, true, true],
  [true, false, true],
  [false, true, false]
]

FIVE_CELL_ROW = [
  [true, true, true, true, true]
]

TEN_CELL_ROW = [
  [true, true, true, true, true, true, true, true, true, true]
]

EXPLODER = [
  [true, false, true, false, true],
  [true, false, false, false, true],
  [true, false, false, false, true],
  [true, false, false, false, true],
  [true, false, true, false, true]
]

# grid configuration
GRID_HEIGHT = 15
GRID_WIDTH = 45
LIFESPAN = 40 # number of ticks before game finishes
DISPLAY_ALIVE = "\u25FD".encode('utf-8')
DISPLAY_DEAD = "\u25FE".encode('utf-8')

# game of life
def start(seed, grid_height, grid_width, lifespan = nil)
  size_error = "Error: grid height and/or grid width too small for seed"
  if seed.size >= grid_height || seed.first.size >= grid_width
    return puts size_error
  end

  grid = create_empty_square_grid(grid_height, grid_width)
  embed(seed, grid)
  game_of_life(grid, lifespan)
end

def create_empty_square_grid(height, width)
  grid = []

  height.times do
    grid << []
  end

  grid.each do |row|
    width.times do
      row << false
    end
  end

  grid
end

def embed(seed, grid)
  seed_height = seed.size
  seed_width = seed.first.size
  margin_top = (grid.size - seed_height) / 2
  margin_left = (grid.first.size - seed_width) / 2

  (0...seed_height).each do |row_index|
    (0...seed_width).each do |col_index|
      grid[row_index + margin_top][col_index + margin_left] =
        seed[row_index][col_index]
    end
  end
end

def game_of_life(grid, lifespan)
  loop do
    system 'clear'

    display(grid)

    puts
    sleep 0.2
    break if stable?(grid)

    tick(grid)
    if lifespan
      lifespan -= 1
      break if lifespan == 0
    end
  end
end

def display(grid)
  display_grid = create_empty_square_grid(grid.size, grid.first.size)

  grid.each_with_index do |row, row_index|
    row.each_with_index do |cell, col_index|
      if alive?(cell)
        display_grid[row_index][col_index] = DISPLAY_ALIVE
      else
        display_grid[row_index][col_index] = DISPLAY_DEAD
      end
    end
  end

  display_strings = []
  display_grid.each { |row| display_strings << row.join }
  puts display_strings
end

def stable?(grid)
  grid == build_next_grid(grid)
end

def tick(grid)
  next_grid = build_next_grid(grid)
  overwrite_values(grid, next_grid)
end

def build_next_grid(grid)
  next_grid = create_empty_square_grid(grid.size, grid.first.size)

  grid.each_with_index do |row, row_index|
    row.each_index do |col_index|
      alive_neighbours = count_alive(neighbours(row_index, col_index, grid))

      next_grid[row_index][col_index] =
        if alive_neighbours == 2
          grid[row_index][col_index]
        elsif alive_neighbours == 3
          true
        else
          false
        end
    end
  end

  next_grid
end

def neighbours(row_index, col_index, grid)
  row_above = grid[row_index - 1]
  current_row = grid[row_index]
  row_below = grid[plus_one(row_index, grid.size)]

  to_the_left = col_index - 1
  to_the_right = plus_one(col_index, grid.first.size)

  [row_above[to_the_left], row_above[col_index], row_above[to_the_right],
   current_row[to_the_left], current_row[to_the_right],
   row_below[to_the_left], row_below[col_index], row_below[to_the_right]]
end

def plus_one(index, dimension)
  if index == dimension - 1
    0
  else
    index + 1
  end
end

def count_alive(cells)
  cells.count { |cell| alive?(cell) }
end

def alive?(cell)
  cell
end

def overwrite_values(grid, next_grid)
  grid.each_with_index do |row, row_index|
    row.each_index do |col_index|
      grid[row_index][col_index] = next_grid[row_index][col_index]
    end
  end
end

#
start(EXPLODER, GRID_HEIGHT, GRID_WIDTH, LIFESPAN)
