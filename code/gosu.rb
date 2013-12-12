
require 'gosu'
require_relative 'game_of_life'

class GameWindow < Gosu::Window

  @bg_color
  @width
  @height

  def initialize
    @width = 1200
    @height = 800
    super @width, @height, false
    self.caption = "Conway's Game of Life"

    #background color
    @bg_color = Gosu::Color.new(0xffdddddd)

    #live cell color
    @lc_color = Gosu::Color.new(0xff000000)

    #cell size
    @cs = 10

    @cols = @width/@cs
    @rows = @height/@cs

    @world = World.new(@rows, @cols)
    @world.populate_randomly
    @world.kill_border
    @game = Game.new(@world)

  end

  def update
    @game.tick!
  end

  def draw
    #draw background
    draw_quad(0,      0,       @bg_color,
              @width, 0,       @bg_color,
              @width, @height, @bg_color,
              0,      @height, @bg_color)

    #draw live cells
    @world.cell_grid.each do |row|
      row.each do |c|
        if c.alive?
          draw_quad(c.x*@cs,     c.y*@cs,     @lc_color,
                    c.x*@cs+@cs, c.y*@cs,     @lc_color,
                    c.x*@cs+@cs, c.y*@cs+@cs, @lc_color,
                    c.x*@cs,     c.y*@cs+@cs, @lc_color)
        end
      end
    end
  end

  def needs_cursor?
    true
  end

end

window = GameWindow.new
window.show
