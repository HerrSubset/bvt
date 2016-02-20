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
  def self.get_games_section(start_date, end_date)
    format = "%Y-%m-%d"
    s = start_date.strftime(format)
    e = end_date.strftime(format)
    json_file = Net::HTTP.get('volley-avf.be',
                "/bolt/kalenders?co=0&cl=0&v=#{s}&t=#{e}&f=json")

    games = JSON.parse(json_file)
    return games["items"]
  end


  def self.get_season_dates
    today = Date.today
    end_date = nil
    start_date = nil

    if today.month > 5
      #download season that's running this and following year
      start_date = Date.new(today.year, 8, 31)
      end_date = Date.new(today.year + 1, 5, 31)

    else
      #download season running this and the previous year
      start_date = Date.new(today.year - 1, 8, 31)
      end_date = Date.new(today.year, 5, 31)
    end
  end



  #we can only load 500 AVF games at a time, so we have to build the games
  #array piece by piece
  def self.get_games
    #get the season start and end date
    season_start, season_end = get_season_dates

    return get_games_section(Date.new(2015,8,31), Date.new(2016,5,31))
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
