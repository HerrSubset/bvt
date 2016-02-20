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


    #add scores if they're available
    if game_hash["score"] != "-"
      home_s = game_hash["score"][0]
      away_s = game_hash["score"][2]

      return Bvt::Game.new(id, home_t, away_t, d, home_s, away_s)

    #return game without scores
    else
      return Bvt::Game.new(id, home_t, away_t, d)
    end
  end



  #download the AVF games in JSON format and parse them into an array
  def self.get_games_section(start_date, end_date)
    puts "[INFO] downloading from #{start_date.to_s} onwards"
    format = "%Y-%m-%d"
    s = start_date.strftime(format)
    e = end_date.strftime(format)
    json_file = Net::HTTP.get('volley-avf.be',
                "/bolt/kalenders?co=0&cl=0&v=#{s}&t=#{e}&f=json")

    games = JSON.parse(json_file)
    return games["items"]
  end



  #returns the start and end date of a season. The dates are those of the
  #current season, and otherwise the next one.
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

    return start_date, end_date
  end



  #we can only load 500 AVF games at a time, so we have to build the games
  #array piece by piece
  def self.get_games
    #container array for storing all games
    games = Array.new

    #get the season start and end date
    season_start, season_end = get_season_dates

    tmp_games = nil

    #keep looping until all games were downloaded
    begin
      tmp_games = get_games_section(season_start, season_end)

      #add games if they're not in there yet
      tmp_games.each do |g|
        if !games.include?(g)
          games.push(g)
        end
      end

      #get latest date of the last downloaded part and use that as input for
      #the next download
      season_start = Date.parse(tmp_games[-1]["date"]) - 1

    end while tmp_games.length == 500

    puts "[INFO] There are #{games.length} games in the AVF federation"
    return games
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
