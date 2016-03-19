require 'net/http'
require 'json'
require 'open-uri'

# implement load script for VVB federation
class Bvt::VvbLoader < Loader
  # creates a new game given a game hash
  def self.create_game(game_hash)
    home_t = game_hash['thuisploeg']
    away_t = game_hash['bezoekers']
    id = game_hash['WNR']

    date = Date.parse(game_hash['Datum'])
    hour = game_hash['aanvangsuur'][0..1].to_i
    minutes = game_hash['aanvangsuur'][3..4].to_i
    d = DateTime.new(date.year, date.month, date.day, hour, minutes)

    # check if results are available
    if game_hash['resulthoofd'] != ''
      home_s = game_hash['resulthoofd'][0]
      away_s = game_hash['resulthoofd'][4]

      Bvt::Game.new(id, home_t, away_t, d, home_s, away_s)

    # return game without scores
    else
      Bvt::Game.new(id, home_t, away_t, d)
    end
  end

  # creates a league stub from one of the data items downloaded with the
  # get_leagues_stub_data_list function
  def self.get_league_stub(stub_data)
    Bvt::LeagueStub.new(stub_data['reeksnaam'], stub_data['reeksafkorting'])
  end

  # downloads the data items that contain both the name and the download
  # parameter for all the leagues in this federation
  def self.get_leagues_stub_data_list
    uri = URI('http://volleybieb.be/AjaxVVBWedstijden.php')

    # get a JSON file containing all league names and their abbreviations
    post_options = { 'wattedoen' => '2',
                     'reekstype' => '1',
                     'provincie' => '0' }
    json_file = Net::HTTP.post_form(uri, post_options).body

    JSON.parse(json_file)
  end

  # downloads game information of a given league
  def self.get_league_games(league_stub)
    url = 'http://volleybieb.be/AjaxVVBWedstijden.php?wattedoen=1&provincie=0'\
          "&reeks=#{league_stub.post_parameter}&competitie=1&team=0&"\
          'datumbegin=0&datumeind=0&stamnummer=0'
    tmp_file = open(url)
    json_file = tmp_file.read
    JSON.parse(json_file)
  end
end
