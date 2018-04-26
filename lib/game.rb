require 'set'
require 'byebug'

class Game

	def initialize
		@biarray = [['.','.','.'],['.','.','.'],['.','.','.']]
		@role_to_move = "X moves"
		@role_changer = 0
	end

	def player_sign(mark, x, y) #
		@role_to_move = "#{mark} moves"
		if @biarray[x][y] != "."
			@role_changer += 2
			:invalid
		else
			@role_changer += 1
			@biarray[x][y] = mark
			:ok
		end
	end

	def move(x,y)
	  if x >= 0 && y >= 0 && x <= 2 && y <= 2
			if state[:game_state] = :on
				if @role_changer.even?
				  player_sign("X", x, y)
			  else
		  	  player_sign("O", x, y)
		  	end
		  else
		  	:invalid
		  end
	  else
	    :invalid
	  end
	end

	def same_value(array)
		array.uniq.length == 1
	end
	
	def inverse
		(0..2).map { |index| @biarray.map { |line| line[index] }}
	end

	def main_diagonal_process
		@main_diagonal = []
		for i in 0..2
			if @biarray[i][i] == 'X'
				@main_diagonal << 'X'
			elsif @biarray[i][i] == 'O'
				@main_diagonal << 'O'
			else
				""
			end
		end
		same_value(@main_diagonal) ? @role_to_move = "#{@main_diagonal[0]} won" : ""
 		same_value(@main_diagonal)
	end

	def second_diagonal_process
		@second_diagonal = []
		for i in 0..2
			if @biarray[i][3-i-1] == 'X'
				@second_diagonal << 'X'
			elsif @biarray[i][3-i-1] == 'O'
				@second_diagonal << 'O'
			else
				""
			end
		end
		same_value(@second_diagonal) ? @role_to_move = "#{@second_diagonal[0]} won" : ""
		same_value(@second_diagonal)
	end

	def lines_checker
		if @biarray.any? { |line| ['X', 'O'].any? { |mark| line.all? { |val| val == mark } } }
      @role_to_move = "#{@role_changer % 2 == 0 ? 'X' : 'O'} won"
			true
		elsif inverse.any? { |line| ['X', 'O'].any? { |mark| line.all? { |val| val == mark  } } }
			@role_to_move = "#{@role_changer % 2 == 0 ? 'X' : 'O'} won"
			true			
		else
			false
		end
	end
		
	def draw_checker
		@biarray.map do |array| 
			array.map do |e| 
				if e == "."  
					false 
				else 
					@role_to_move = "Draw"
					true
				end
			end
		end
	end

	def play_on #Return on if game is still on and over if game is over
		if main_diagonal_process || second_diagonal_process || lines_checker || draw_checker
			state[:game_state] = :over
		else
			state[:game_state] = :on
		end
	end
	
	def state
		{
			:board => @biarray,
			:game_state => play_on,
			:detail => @role_to_move
		}
	end


end