require 'byebug'
require_relative 'game_with_id'

class ComputerPlayer

	def generate_move(state)
		free_positions = []
		game_board = state[:board]
		game_state = state[:game_state]
		
		if game_state == :on
			game_board.each_with_index do |line, x|
				line.each_with_index do |elem, y|
					if elem == ""
					  free_positions << "#{x}#{y}"
					end
				end
			end
		end

	  params = Random.new
	  element = params.rand(free_positions.size-1)
		positions = free_positions[element].split("")
		coordinates = { x: positions[0].to_i, y: positions[1].to_i }
	end

end