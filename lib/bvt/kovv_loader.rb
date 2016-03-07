require "net/http"
require "json"
require "open-uri"



class Bvt::KovvLoader

  #creates a new game given a game hash
  def self.create_game(game_hash)
    home_t = game_hash["thuisploeg"]
    away_t = game_hash["bezoekers"]
    id = game_hash["WNR"]

    date = Date.parse(game_hash["Datum"])
    hour = game_hash["aanvangsuur"][0..1].to_i
    minutes = game_hash["aanvangsuur"][3..4].to_i
    d = DateTime.new(date.year, date.month, date.day, hour, minutes)

    #check if results are available
    if game_hash["resulthoofd"] != ""
      home_s = game_hash["resulthoofd"][0]
      away_s = game_hash["resulthoofd"][4]

      return Bvt::Game.new(id, home_t, away_t, d, home_s, away_s)

    #return game without scores
    else
      return Bvt::Game.new(id, home_t, away_t, d)
    end
  end



  #returns a hash containing all the leagues of this federation
  def self.load

  end



  #return an array containing the league stubs that can be used to dynamically
  #load leagues later on.
  def self.get_league_names
    res = Array.new

    uri = URI("http://volleybieb.be/AjaxVVBWedstijden.php")

    #get a JSON file containing all league names and their abbreviations
    post_options = {"wattedoen" => "2", "reekstype" => "1", "provincie" => "6"}
    json_file = Net::HTTP.post_form(uri, post_options).body

    leagues = JSON.parse(json_file)

    #create league stubs for all the leagues
    leagues.each do |l|
      tmp = Bvt::LeagueStub.new(l["reeksnaam"], l["reeksafkorting"])
      res.push(tmp)
    end

    return res
  end



  #load a league based on a parameter that has to be given to an online form
  #or API
  def self.load_league(post_param)
    res = nil

    if post_param
      tmp_file = open("http://volleybieb.be/AjaxVVBWedstijden.php?wattedoen=1&provincie=6&reeks=#{post_param}&competitie=1&team=0&datumbegin=0&datumeind=0&stamnummer=0")
      json_file = tmp_file.read
      games = JSON.parse(json_file)

      #create the league if games were Found
      if games && games.length > 0
        res = Bvt::League.new(name)
        games.each do |g|
          res.add_game(create_game(g))
        end
      end
    end

    return res
  end
end
