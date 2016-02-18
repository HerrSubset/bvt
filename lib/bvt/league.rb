class Bvt::League

  #constructor
  def initialize(name)
    @name = name
    @games = Array.new
  end

  #getters
  attr_reader :name
  attr_reader :games


  #add a game to the list of games
  def add_game(game)
    if game.class == Bvt::Game
      @games.push(game)
    end
  end
end
