require "net/http"
require "json"
require "date"
require "nokogiri"
require "open-uri"

class Bvt::AvfLoader < Loader

  #takes a game hash as input and transforms it into a Bvt::Game object
  def self.create_game(game_hash)
    home_t = game_hash["team1"]
    away_t = game_hash["team2"]
    id = game_hash["id"]

    date = Date.parse(game_hash["date"])
    hour = game_hash["time"][0..1].to_i
    minutes = game_hash["time"][3..4].to_i
    d = DateTime.new(date.year, date.month, date.day, hour, minutes)


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



  #downloads the data items that contain both the name and the download
  #parameter for all the leagues in this federation
  def self.get_leagues_stub_data_list
    doc = Nokogiri::HTML(open('http://volley-avf.be/bolt/kalenders'))
    leagues_holder = doc.css("select#comp_comp")[0]
    leagues = leagues_holder.css("option").to_a
    leagues.delete_at(0)  #first item is empty
    return leagues
  end



  #creates a league stub from one of the data items downloaded with the
  #get_leagues_stub_data_list function
  def self.get_league_stub(league)
    return Bvt::LeagueStub.new(league.text, league["value"].to_i)
  end



  #downloads game information of a given league
  def self.get_league_games(league_stub)
    res = Array.new

    #date parameters
    start_date, end_date = get_season_dates
    format = "%Y-%m-%d"
    s = start_date.strftime(format)
    e = end_date.strftime(format)

    #league parameter
    league_parameter = league_stub.post_parameter

    json_file = Net::HTTP.get('volley-avf.be',
                "/bolt/kalenders?co=#{league_parameter}&cl=0&v=#{s}&t=#{e}&f=json")

    #check if the games actually got downloaded
    if json_file.include?("404 Not Found")
      puts "[ERROR] could not complete download"

    #process the downloads
    else
      games = JSON.parse(json_file)
      res = games["items"]
    end

    return res
  end
end
