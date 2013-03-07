require 'pp'
require 'pry'

class Grid
  attr_accessor :rows, :width, :height
	def initialize(width, height)
    @width, @height = width, height
    @rows = Array.new(height) { Array.new(width) }
  end

  def populate
    @rows.each_with_index do |row, x|
      row.each_with_index do |cell, y|
        row[y] = Cell.new(x, y, rand(2) == 1 ? true : false)
      end
      @rows[x] = row
    end
  end

  def step
    @temp_rows = @rows
    @rows.each_with_index do |row, x|
      temp_row = row
      row.each_with_index do |cell, y|
        neighbors = number_of_neighbors(x, y)
        temp_row[y] = Cell.new(x, y)
        puts "#{y} = #{row[y].alive? ? 'alive' : 'dead'}"
        if row[y].alive?
          temp_row[y] = Cell.new(x, y, true) if neighbors == 2 or neighbors == 3
        else
          temp_row[y] = Cell.new(x, y, true) if neighbors == 3
        end
      end
      @temp_rows[x] = temp_row
    end
    @rows = @temp_rows
  end

  def number_of_neighbors(x, y)
    count = 0
    -1.upto(1) do |_x|
      -1.upto(1) do |_y|
        # binding.pry if self.rows[x+_x % @width][y+_y % @height].class != Cell
        count += 1 if self.rows[(x+_x) % @width][(y+_y) % @height].alive? unless _x == 0 and _y == 0
      end
    end
    count
  end
end

class Cell
  def initialize(x, y, state = false)
    @x, @y, @state = x, y, state
  end

  def alive?
    @state
  end

  def to_s
    @state == true ? "1" : "0"
  end
end

grid = Grid.new(5, 5)
grid.populate
pp grid.rows
puts
grid.step
pp grid.rows
puts
grid.step
pp grid.rows