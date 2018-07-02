# Using game.rb to build a console-based TicTacToe
require_relative 'game'

def display_square_matrix mat
  mat.each do |line|
    line.each do |col|
      print ' ' + col
    end
    puts
  end
  puts
end

game = Game.new
state = game.state

while state[:game_state] == :on
  display_square_matrix state[:board]

  valid_move = false
  until valid_move
    print "#{state[:detail]}: "
    x, y = gets.chomp.split('').map(&:to_i)

    valid_move = game.move(x, y) == :ok
    if !valid_move 
      puts 'Invalid move, try again!'
    end
  end

  state = game.state
end

display_square_matrix state[:board]
puts "GAME OVER - #{state[:detail]}"