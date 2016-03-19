require 'open-uri'
require 'json'

# implements the load script for the KLVV league
class Bvt::KlvvLoader < Loader
  # downloads the data items that contain both the name and the download
  # parameter for all the leagues in this federation
  def self.get_leagues_stub_data_list
    s, e = get_season_dates

    # get a JSON file containing all league names and their abbreviations
    url = 'https://klvv.be/server/series.php?trophy=false&'\
          "season=#{s.year}-#{e.year}"
    f = open(url)
    json_file = JSON.parse(f.read)

    # create an array containing arrays with league names on index 0
    # and parameters on index 1
    res = []

    # ugly code, check the downloaded json file for how it works
    json_file.each do |section|
      section['serieSorts'].each do |level|
        name = level['name']
        level['series'].each do |league|
          tmp = []
          tmp.push("#{name} #{league['letter']}")
          tmp.push(league['id'])
          res.push(tmp)
        end
      end
    end

    res
  end

  # creates a league stub from one of the data items downloaded with the
  # get_leagues_stub_data_list function
  def self.get_league_stub(stub_data)
    Bvt::LeagueStub.new(stub_data[0], stub_data[1])
  end

  # downloads game information of a given league
  def self.get_league_games(league_stub)
    url = 'https://klvv.be/server/seriedata.php?serieId='\
          "#{league_stub.post_parameter}"
    tmp_file = open(url)
    json_file = JSON.parse(tmp_file.read)
    json_file['matches']
  end

  # creates a new game given a game hash
  def self.create_game(game_hash)
    home_t = game_hash['homeTeam']
    away_t = game_hash['visitorTeam']
    id = game_hash['id']

    # get time and add 2 hours for timezone reasons
    timestamp = game_hash['datetime'] + 7_200_000
    d = DateTime.strptime(timestamp.to_s, '%Q')

    # check if results are available
    if game_hash['homeSets'] != 0 || game_hash['visitorSets'] != 0
      home_s = game_hash['homeSets']
      away_s = game_hash['visitorSets']

      return Bvt::Game.new(id, home_t, away_t, d, home_s, away_s)

    # return game without scores
    else
      return Bvt::Game.new(id, home_t, away_t, d)
    end
  end
end
