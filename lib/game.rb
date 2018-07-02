require 'byebug'

class Game

  def initialize
    @biarray = [["","",""],["","",""],["","",""]]
    @role_to_move = "X"
    @role_changer = 0
    @state = :on
  end

  def move(x,y)
    if x >= 0 && y >= 0 && x <= 2 && y <= 2
      if @state == :on
        @role_changer.even? ? player_sign("X", x, y) : player_sign("O", x, y)
      else
        :invalid
      end
    else
      :invalid
    end
  end

  def player_sign(mark, x, y) # TO DO: divide this method 
    if @biarray[x][y] != ""
      @role_changer += 2
      @role_to_move = "#{mark == 'X' ? 'O' : 'X'}"
      :invalid
    else
      @role_changer += 1
      @role_to_move = "#{mark == 'X' ? 'O' : 'X'}"
      @biarray[x][y] = mark
      check_game_state
      :ok
    end
  end

  def same_value(array)
    array.uniq.length == 1 && ['X', 'O'].include?(array.first)
  end
  
  def inverse(array)
    (0..2).map { |index| array.map { |line| line[index] }}
  end

  def main_diagonal_process
    is_valid = same_value([@biarray[0][0], @biarray[1][1], @biarray[2][2]])
    @role_to_move = "#{@biarray[0][0]} won" if is_valid
  end

  def second_diagonal_process
    second_diagonal = []
    for i in 0..2
      second_diagonal << @biarray[i][3-i-1]
    end
    same_value(second_diagonal) ? @role_to_move = "#{second_diagonal[0]} won" : ""
    same_value(second_diagonal)
  end

  def lines_checker
    if @biarray.any? { |line| ['X', 'O'].any? { |mark| line.all? { |val| val == mark } } }
      @role_to_move = "#{@role_changer % 2 == 0 ? 'O' : 'X'} won"
      true
    else
      false
    end    
  end

  def columns_checker
    if inverse(@biarray).any? { |line| ['X', 'O'].any? { |mark| line.all? { |val| val == mark  } } }
      @role_to_move = "#{@role_changer % 2 == 0 ? 'O' : 'X'} won"
      true
    else
      false
    end   
  end
    
  def draw_checker
    is_draw = @biarray.flatten.none? { |pos| pos == "" }
    @role_to_move = "draw" if is_draw
    is_draw
  end

  def check_game_state #Return :on if game is still on and :over if game is over
    if main_diagonal_process || second_diagonal_process || lines_checker || columns_checker || draw_checker
      vector_index
      @state = :over
    else
      @state = :on
    end
  end

  def check_vectors(no_element)
    inverted = inverse(@biarray)
    @biarray[no_element].uniq.size == 1 || inverted[no_element].uniq.size == 1
  end

  def vector_index
    params = []
    (0..2).each do |index|
      if check_vectors(index)
        for i in 0..2
          lines_checker ? params << ["#{index}#{i}"] : ""
          columns_checker ? params << ["#{i}#{index}"] : ""
          main_diagonal_process ? params << ["#{i}#{i}"] : ""
          second_diagonal_process ? params << ["#{i}#{3-i-1}"] : ""
        end
      end
    end
    return params
  end

  def state
    {
      board: @biarray,
      game_state: @state,
      detail: @role_to_move,
    }
  end

end