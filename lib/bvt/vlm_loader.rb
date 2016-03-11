require "open-uri"
require "nokogiri"



class Bvt::VlmLoader < Loader

  #downloads the data items that contain both the name and the download
  #parameter for all the leagues in this federation
  def self.get_leagues_stub_data_list
    res = []
    s,e = get_season_dates
    #the federation is small enough to provide this data ourself

    res.push(["Dames Provinciaal 1", "d1#{s.year}"])
    res.push(["Dames Provinciaal 2A", "d2a#{s.year}"])
    res.push(["Dames Provinciaal 2B", "d2b#{s.year}"])
    res.push(["Dames Provinciaal 3", "d3#{s.year}"])

    res.push(["Heren Provinciaal 1", "h1#{s.year}"])
    res.push(["Heren Provinciaal 2A", "h2a#{s.year}"])
    res.push(["Heren Provinciaal 2B", "h2b#{s.year}"])
    res.push(["Heren Provinciaal 3", "h3#{s.year}"])

    res.push(["Regio Oost", "ro#{s.year}"])

    res.push(["Interbedrijven A", "iba#{s.year}"])
    res.push(["Interbedrijven B", "ibb#{s.year}"])

    return res
  end



  #creates a league stub from one of the data items downloaded with the
  #get_leagues_stub_data_list function
  def self.get_league_stub(stub_data)
    return Bvt::LeagueStub.new(stub_data[0], stub_data[1])
  end



  #downloads game information of a given league
  def self.get_league_games(league_stub)
    res = []

    doc = Nokogiri::HTML(open("http://vlmbrabant.be/compet/uitslagen-#{league_stub.post_parameter}.htm"))
    tables = doc.css("body table")

    tables.each do |t|
      #add all the table rows of this table to the res array
      res.concat(t.css("tr"))
    end

    return res
  end



  #creates a new game given a table row
  #TODO: create a unique ID for all games
  def self.create_game(game_row)
    tds = game_row.css("td")
    home_t = tds[4].text
    away_t = tds[5].text
    id = tds[0].text

    d = Date.strptime(tds[2].text, "%d/%m/%y")
    hour = tds[3].text[0..1].to_i
    minutes = tds[3].text[3..4].to_i
    date = DateTime.new(d.year, d.month, d.day, hour, minutes)

    #check if results are available
    if tds[6].text != ""
      home_s = tds[6].text[0]
      away_s = tds[6].text[2]

      return Bvt::Game.new(id, home_t, away_t, date, home_s, away_s)

    #return game without scores
    else
      return Bvt::Game.new(id, home_t, away_t, date)
    end
  end

end
