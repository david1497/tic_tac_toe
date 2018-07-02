require 'byebug'

class GameWithId
  attr_reader :id, :game

  def initialize id
    @id = id
    @game = Game.new
  end

  def method_missing(name, *args)
    @game.send(name, *args)
  end

  def to_json
    {
      id: id,
      state: @game.state,
      game_state: @game.state[:game_state],
      game_role: @game.state[:detail]
    }
  end

end