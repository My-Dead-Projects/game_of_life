
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
    death_list = []
    spawn_list = []
    (1..@world.rows-2).each do |i|
      (1..@world.cols-2).each do |j|
        if live_neighbors(i,j) < 2
          death_list << [i, j]
        end
        if live_neighbors(i,j) > 3
          death_list << [i, j]
        end
        if live_neighbors(i,j) == 3
          spawn_list << [i, j]
        end
      end
    end
    death_list.each do |e|
      @world.cell_grid[e[0]][e[1]].die!
    end
    spawn_list.each do |e|
      @world.cell_grid[e[0]][e[1]].spawn!
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

    count_cells.([ [x-1,y-1], [x-1,y], [x-1,y+1], [x,y+1],
                   [x+1,y+1], [x+1,y], [x+1,y-1], [x,y-1] ])
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

    def populate_randomly
      @cell_grid.each do |row|
        row.each do |cell|
          cell.alive = [true, false, false, false].sample
        end
      end
    end

    def kill_border
      @cell_grid[0].each { |cell| cell.die! }
      @cell_grid[@rows-1].each { |cell| cell.die! }
      (0..@rows-1).each do |row|
        @cell_grid[row][0].die!
        @cell_grid[row][@cols-1].die!
      end
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

  def spawn!
    @alive = true
  end

  def initialize(x, y)
    @alive = false
    @x = x
    @y = y
  end

end
