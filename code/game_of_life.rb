
class Game

  attr_accessor :world, :seeds

  def initialize(world = World.new, seeds = [])
    @world = world
    @seeds = seeds
    seeds.each do |seed|
      @world.cell_grid[seed[0]][seed[1]].alive = true
    end
  end

  def tick!
    die_list = []
    (0..@world.rows-1).each do |i|
      (0..@world.cols-1).each do |j|
        if live_neighbors(i,j) == 1
          die_list << [i, j]
        end
      end
    end
    die_list.each do |e|
      @world.cell_grid[e[0]][e[1]].die!
    end
  end

  def live_neighbors(x,y)

    count = 0

    count_cells = lambda do |cells|
      cg = @world.cell_grid
      cells.each do |cell|
        count += 1 if cg[cell[0]][cell[1]].alive?
      end
    end

    if x < 0 or x > world.rows or y < 0 or y > world.cols
      nil
    elsif x == 0
      if y == 0
        #top-left corner
        count_cells.([ [0,1], [1,0], [1,1] ])
      elsif y < world.cols-1
        #top edge
        count_cells.([ [0,y-1], [1,y-1], [1,y], [1,y+1], [0,y+1] ])
      elsif y == world.cols-1
        #top-right corner
        count_cells.([ [0,y-1], [1,y-1], [1,y] ])
      end
    elsif x < world.rows-1
      if y == 0
        #left edge
        count_cells.([ [x-1,0], [x-1,1], [x,1], [x+1,1], [x+1,0] ])
      elsif y < world.cols-1
        #center area
        count_cells.([ [x-1,y-1], [x-1,y], [x-1,y+1], [x,y+1],
                       [x+1,y+1], [x+1,y], [x+1,y-1], [x,y-1] ])
      elsif y == world.cols-1
        #right edge
        count_cells.([ [x-1,y], [x-1,y-1], [x,y-1], [x+1,y-1], [x+1,y] ])
      end
    elsif x == world.rows-1
      if y == 0
        #bottom-left corner
        count_cells.([ [x-1,0], [x-1,1], [x,1] ])
      elsif y < world.cols-1
        #bottom edge
        count_cells.([ [x,y-1], [x-1,y-1], [x-1,y], [x-1,y+1], [x,y+1] ])
      elsif y == world.cols-1
        #bottom-right corner
        count_cells.([ [x,y-1], [x-1,y-1], [x-1,y] ])
      end
    end

    count

  end
end

class World

  attr_accessor :rows, :cols, :cell_grid

  def initialize(rows=3, cols=3)
    @rows = rows
    @cols = cols
    @cell_grid = Array.new(rows) do |row|
      Array.new(cols) do |col|
        Cell.new(col,row)
      end
    end
  end

  # for debugging
  def print_cell_grid
    puts
    cell_grid.each do |a|
      a.each do |e|
        if e.alive?
          print ' X'
        else
          print ' -'
        end
      end
      puts
    end
  end

end

class Cell

  attr_accessor :alive, :x, :y

  def alive?
    @alive
  end

  def dead?
    not @alive
  end

  def die!
    @alive = false
  end

  def initialize(x, y)
    @alive = false
    @x = x
    @y = y
  end

end
