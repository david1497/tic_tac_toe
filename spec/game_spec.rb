require 'spec_helper'
require 'game'
require 'byebug'

describe Game, "A simple TicTacToe game implementation" do
  before :each do
    @game = Game.new
  end

  describe "#new" do
    it "returns a new Game object" do
      @game.should be_an_instance_of Game
    end
  end

  describe "#move" do
    it "marks the provided position on the board with the character whose next turn it is to move" do
       @game.move(0, 0).should eql :ok 
       board = @game.state[:board]
       board[0][0].should eql 'X'

       @game.move(2, 1).should eql :ok
       board = @game.state[:board]
       board[2][1].should eql 'O'
    end

    it "checks that the provided position doesn't fall outside the board limits before making the move" do
      @game.move(0, -1).should eql :invalid
      @game.move(2, 4).should eql :invalid
      # etc
    end

    it "checks that the provided position isn't already taken before making the move" do
      @game.move(0, 0).should eql :ok
      @game.move(0, 0).should eql :invalid
      # etc
    end

    it "checks that the game is still on before making the move" do
      @game.move 0, 0
      @game.move 1, 0
      @game.move 0, 1
      @game.move 1, 1
      @game.move 0, 2
      # at this point X has won
      
      @game.move(2, 2).should eql :invalid # an otherwise valid move...
    end

    it "takes turns correctly" do
      @game.state[:detail].should eql 'X moves'

      @game.move 0, 0
      @game.state[:detail].should eql 'O moves'

      @game.move 0, 1
      @game.state[:detail].should eql 'X moves'
    end
  end

  describe "#state" do
    it "returns a hash containing 3 keys: board (array of 3 arrays with 3 elements), game_state and detail" do
      state = @game.state
      
      state.should be_an_instance_of Hash

      state[:board].should be_an_instance_of Array
      state[:board].size.should eql 3
      state[:board].map { |a| a.size }.should eql [3, 3, 3]

      state.keys.should eql [:board, :game_state, :detail]
    end

    it "returns a { empty board, :on, 'X moves' } state for a new Game" do
      state = @game.state

      state[:board].should eql [['.','.','.'], ['.','.','.'], ['.','.','.']]
      state[:game_state].should eql :on
      state[:detail].should eql 'X moves'
    end

    it "returns a { non-empty board containing only '.','X' or 'O' elements, :on, 'X moves' or 'O moves' } state for a Game that had some moves made but it's still on" do
      @game.move 0,0
      @game.move 2,1
      @game.move 1,2

      state = @game.state

      state[:board].flatten.all? { |c| ['.','X','O'].include? c }.should eql true
      state[:game_state].should eql :on
      state[:detail].should match /[X|O] moves/
    end

    it "returns a { non-empty board containing only 'X' and 'O' elements, :over, 'draw' } state for a Game that ended with a Draw" do
      @game.move 0, 0    
      @game.move 1, 0
      @game.move 0, 1
      @game.move 1, 1
      @game.move 1, 2
      @game.move 0, 2
      @game.move 2, 0
      @game.move 2, 2
      @game.move 2, 1

      state = @game.state

      state[:board].flatten.all? { |c| ['X','O'].include? c }.should eql true
      state[:game_state].should eql :over
      state[:detail].should eql 'draw'
    end

    it "returns a { non-empty board, :over, 'X won' } state for a Game that ended with a victory for X" do
      @game.move 0, 0
      @game.move 1, 0
      @game.move 0, 1
      @game.move 1, 1
      @game.move 0, 2

      state = @game.state

      state[:board].flatten.all? { |c| ['.','X','O'].include? c }.should eql true
      state[:game_state].should eql :over
      state[:detail].should eql 'X won'
    end

    it "returns a { non-empty board, :over, 'O won' } state for a Game that ended with a victory for O" do
      @game.move 0, 0
      @game.move 1, 0
      @game.move 0, 1
      @game.move 1, 1
      @game.move 2, 2
      @game.move 1, 2

      state = @game.state

      state[:board].flatten.all? { |c| ['.','X','O'].include? c }.should eql true
      state[:game_state].should eql :over
      state[:detail].should eql 'O won'
    end

    it "returns a { non-empty board, :over, 'X won' } state for a Game that ended with a victory for X on the main diagonal" do
      @game.move 0, 0
      @game.move 0, 1
      @game.move 1, 1
      @game.move 0, 2
      @game.move 2, 2

      state = @game.state

      state[:board].flatten.all? { |c| ['.','X','O'].include? c }.should eql true
      state[:game_state].should eql :over
      state[:detail].should eql 'X won'
    end

    it "returns a { non-empty board, :over, 'X won' } state for Game that ended with a victory for O on the main diagonal" do
      @game.move 1, 0 
      @game.move 0, 0
      @game.move 2, 0
      @game.move 1, 1
      @game.move 2, 1
      @game.move 2, 2

      state = @game.state

      state[:board].flatten.all? { |c| ['.','X','O'].include? c }.should eql true
      state[:game_state].should eql :over
      state[:detail].should eql 'O won'
    end

    it "returns a { non-empty board, :over, 'X won' } state for a Game that ended with a victory for X on the second diagonal" do
      @game.move 0, 2
      @game.move 0, 1
      @game.move 1, 1
      @game.move 1, 2
      @game.move 2, 0

      state = @game.state

      state[:board].flatten.all? { |c| ['.','X','O'].include? c }.should eql true
      state[:game_state].should eql :over
      state[:detail].should eql 'X won'
    end
    # TODO check that it correctly detects victories on lines, columns and diag's etc
  end
end
