require 'rspec'
require_relative '../code/game_of_life'

describe 'Game of life' do

  context 'World' do
    subject { World.new }
    it { should be_a World }
    it { should respond_to :rows }
    it { should respond_to :cols }
    it { should respond_to :cell_grid }
    it { should respond_to :populate_randomly }
  end

  context 'World.cell_grid' do
    subject { World.new.cell_grid }
    it { should be_an Array }
    it 'should contain Arrays' do
      subject.each { |e| e.should be_an Array }
    end
    it 'should ultimately contain Cells' do
      subject.each { |e| e.each { |f| f.should be_a Cell } }
    end
  end

  context 'Cell' do
    subject { Cell.new(5,7) }
    it { should be_a Cell }

    it { should respond_to :alive }
    its(:alive) { should == false }
    it { should respond_to :alive? }
    its(:alive?) { should == false }

    it { should respond_to :x }
    its(:x) { should == 5 }

    it { should respond_to :y }
    its(:y) { should == 7 }
  end

  context 'Game' do
    subject { Game.new }
    it { should be_a Game }
    it { should respond_to :world }
    it { should respond_to :seeds }
    its(:world) { should be_a World }
    its(:seeds) { should be_an Array }

    it 'should plant seeds properly' do
      game = Game.new(World.new, [[1,2],[0,2]])
      game.world.cell_grid[1][2].should be_alive
      game.world.cell_grid[0][2].should be_alive
    end
  end

  context 'Game.live_neighbors' do
    let(:g1) { Game.new(World.new, [[0,0],[0,2],[1,1],[2,0],[2,2]]) }
    let(:g2) { Game.new(World.new, [[0,1],[1,0],[1,2],[2,1]]) }

    #it 'should yield correct results for the top-left corner cell' do
    #  g1.live_neighbors(0,0).should == 1
    #  g2.live_neighbors(0,0).should == 2
    #end
    #it 'should yield correct results for a top edge cell' do
    #  g1.live_neighbors(0,1).should == 3
    #  g2.live_neighbors(0,1).should == 2
    #end
    #it 'should yield correct results for the top-right corner cell' do
    #  g1.live_neighbors(0,2).should == 1
    #  g2.live_neighbors(0,2).should == 2
    #end
    #it 'should yield correct results for a left edge cell' do
    #  g1.live_neighbors(1,0).should == 3
    #  g2.live_neighbors(1,0).should == 2
    #end
    it 'should yield correct results for a center area cell' do
      g1.live_neighbors(1,1).should == 4
      g2.live_neighbors(1,1).should == 4
    end
    #it 'should yield correct results for a right edge cell' do
    #  g1.live_neighbors(1,2).should == 3
    #  g2.live_neighbors(1,2).should == 2
    #end
    #it 'should yield correct results for the bottom-left corner cell' do
    #  g1.live_neighbors(2,0).should == 1
    #  g2.live_neighbors(2,0).should == 2
    #end
    #it 'should yield correct results for a bottom edge cell' do
    #  g1.live_neighbors(2,1).should == 3
    #  g2.live_neighbors(2,1).should == 2
    #end
    #it 'should yield correct results for the bottom-right corner cell' do
    #  g1.live_neighbors(2,2).should == 1
    #  g2.live_neighbors(2,2).should == 2
    #end
  end

  describe 'Rule' do

    describe '1: Any live cell with fewer than 2 live neighbors should die:' do
      context 'A live cell with 1 live neighbor' do
        it 'should die' do
          game = Game.new(World.new, [[1,1],[0,0]])
          game.tick!
          game.world.cell_grid[1][1].should be_dead
        end
      end
      context 'A live cell with no live neighbors' do
        it 'should die' do
          game = Game.new(World.new, [[1,1]])
          game.tick!
          game.world.cell_grid[1][1].should be_dead
        end
      end
    end
    describe '2: Any live cell with 2 or 3 live neighbors should live:' do
      context 'A live cell with 2 live neighbors' do
        it 'should not die' do
          game = Game.new(World.new, [[0,1], [0,2], [1,1]])
          game.tick!
          game.world.cell_grid[1][1].should be_alive
        end
      end
      context 'A live cell with 3 live neighbors' do
        it 'should not die' do
          game = Game.new(World.new, [[1,1], [0,0], [0,1], [0,2]])
          game.tick!
          game.world.cell_grid[1][1].should be_alive
        end
      end
    end
    describe '3: Any live cell with more than 3 neighbors should die:' do
      context 'A live cell with 4 live neighbors' do
        it 'should die' do
          game = Game.new(World.new, [[1,1], [0,0], [0,1], [0,2], [1,0]])
          game.tick!
          game.world.cell_grid[1][1].should be_dead
        end
      end
      context 'A live cell with 5 live neighbors' do
        it 'should die' do
          game = Game.new(World.new, [[1,1], [0,0], [0,1], [0,2], [1,0], [1,2]])
          game.tick!
          game.world.cell_grid[1][1].should be_dead
        end
      end
      context 'A live cell with 6 live neighbors' do
        it 'should die' do
          game = Game.new(World.new, [[1,1], [0,0], [0,1], [0,2], [1,0], [1,2], [2,0]])
          game.tick!
          game.world.cell_grid[1][1].should be_dead
        end
      end
      context 'A live cell with 7 live neighbors' do
        it 'should die' do
          game = Game.new(World.new, [[1,1], [0,0], [0,1], [0,2], [1,0], [1,2], [2,0], [2,1]])
          game.tick!
          game.world.cell_grid[1][1].should be_dead
        end
      end
      context 'A live cell with 8 live neighbors' do
        it 'should die' do
          game = Game.new(World.new, [[1,1], [0,0], [0,1], [0,2], [1,0], [1,2], [2,0], [2,1], [2,2]])
          game.tick!
          game.world.cell_grid[1][1].should be_dead
        end
      end
    end
    describe '4: Any dead cell with exactly three live neighbours should become alive' do
      context 'A dead cell with 3 live neighbors' do
        it 'should be_dead' do
          game = Game.new(World.new, [[0,0], [0,1], [0,2]])
          game.tick!
          game.world.cell_grid[1][1].should be_alive
        end
      end
    end
  end
end
