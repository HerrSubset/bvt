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


  #return an array listing all the teams in this league
  def get_teams
    res = Array.new

    @games.each do |g|
      #check if home team is in the result array
      if !res.include?(g.home_team)
        res.push(g.home_team)
      end

      #check if away team is in the result array
      if !res.include?(g.away_team)
        res.push(g.away_team)
      end
    end

    return res
  end


  #return an array with all the games belonging to a certain team
  def get_team_games(team)
    res = Array.new

    @games.each do |g|
      if team == g.home_team
        res.push(g)
      end

      if team == g.away_team
        res.push(g)
      end
    end

    return res
  end
end
