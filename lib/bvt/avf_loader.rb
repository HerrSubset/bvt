require "net/http"
require "json"
require "date"

class Bvt::AvfLoader

  #takes a game hash as input and transforms it into a Bvt::Game object
  def self.create_game(game_hash)
    home_t = game_hash["team1"]
    away_t = game_hash["team2"]
    d = Date.parse(game_hash["date"])
    id = game_hash["id"]

    return Bvt::Game.new(id, home_t, away_t, d)
  end

  #download the AVF games in JSON format and parse them into an array
  def self.get_games
    json_file = Net::HTTP.get('volley-avf.be',
                '/bolt/kalenders?co=0&cl=0&v=2015-08-31&t=2016-07-31&f=json')

    games = JSON.parse(json_file)
    return games["items"]
  end


  #returns an array with all the leagues in the AVF federation
  def self.load
    games = get_games

    #create a hash to temporarily store all the leagues
    league_hash = Hash.new

    #add all games to their respective league
    games.each do |g|
      game = create_game(g)
      game_league = g["competition"]

      #check if this game's league exist, otherwise create it
      if league_hash[game_league] == nil
        league_hash[game_league] = Bvt::League.new(game_league)
      end

      #add this game to its league
      league_hash[game_league].add_game(game)
    end

    return league_hash.values
  end
end
