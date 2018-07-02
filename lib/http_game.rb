require 'sinatra'
require 'json'
require 'byebug'
require_relative 'game'
require_relative 'game_with_id'
require_relative 'computer_player'

games = []
id = 1

get '/', :provides => 'html' do
  @games_converted = []
  games.each do |game|
    @games_converted << game.to_json
  end
  erb :index
end

get '/admin', :provides => 'html' do
  @games_converted = []
  games.each do |game|
    @games_converted << game.to_json
  end
  erb :admin
end

get '/game/new' do
  id = games.size + 1
  @new_game = GameWithId.new(id)
  @@type = "singleplayer"

  games << @new_game

  redirect "/game/#{@new_game.id}"
end

get '/game/:id' do |id|
  id = id.to_i
  games.find { |g| g.id == id}.to_json.inspect
  redirect "/" unless games.any? { |g| g.id == id }
  "The game #{id} >> " + games.find { |g| g.id == id }.state[:board].map { |array| "#{array}\n" }.join

  @game_id = id
  @game_type = @@type
  @params = games[id-1].game.vector_index
  @game_state = games[id-1].state[:game_state]
  @game_move = games[id-1].state[:detail]
  @game_board = games[id-1].state[:board]

  erb :game_by_id
end

put '/game/:id' do |id|
  id = id.to_i
  request.body.rewind
  pos_hash = JSON.parse(request.body.read)

  x, y = pos_hash["posx"].to_i, pos_hash["posy"].to_i

  game = games.find { |g| g.id == id }
  board = game.state[:board]
  board[x][y] == "" ? valid_move = true : valid_move = false
  game.move(x, y)

  if valid_move
    computer_move = ComputerPlayer.new.generate_move(game.state)
    game.move(computer_move[:x], computer_move[:y])
  end
end

post '/game/new' do
  id = games.size + 1
  @new_game = GameWithId.new(id)
  @@type = "multiplayer"

  games << @new_game

  redirect "/game/#{@new_game.id}"
end

delete '/game/:id' do |id|
  games.delete_if { |g| g.id == id }
  redirect "/admin"
end