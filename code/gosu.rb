
require 'gosu'
require_relative 'game_of_life'

class GameWindow < Gosu::Window

  @bg_color
  @width
  @height

  def initialize
    @width = 800
    @height = 600
    super @width, @height, false
    self.caption = "Conway's Game of Life"

    @bg_color = Gosu::Color.new(0xffdddddd)
    @bg_color2 = Gosu::Color.new(0xccdddddd)
    @bg_color3 = Gosu::Color.new(0x99dddddd)

    @cols = @width/10
    @rows = @height/10

    @world = World.new
    @world.populate_randomly
    @game = Game.new(@world)

  end

  def update

  end

  def draw
    draw_quad(0,0, @bg_color,
              @width, 0, @bg_color2,
              @width, @height, @bg_color3,
              0, @height, @bg_color2)
  end

  def needs_cursor?
    true
  end

end

window = GameWindow.new
window.show
