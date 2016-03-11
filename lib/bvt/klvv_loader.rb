require "open-uri"
require "json"

class Bvt::KlvvLoader < Loader

  #downloads the data items that contain both the name and the download
  #parameter for all the leagues in this federation
  def self.get_leagues_stub_data_list
    s,e = get_season_dates

    #get a JSON file containing all league names and their abbreviations
    f = open("https://klvv.be/server/series.php?trophy=false&season=#{s.year}-#{e.year}")
    json_file = JSON.parse(f.read)

    #create an array containing arrays with league names on index 0
    #and parameters on index 1
    res = []

    # ugly code, check the downloaded json file for how it works
    json_file.each do |section|
      section["serieSorts"].each do |level|
        name = level["name"]
        level["series"].each do |league|
          tmp = []
          tmp.push("#{name} #{league['letter']}")
          tmp.push(league["id"])
          res.push(tmp)
        end
      end
    end

    return res
  end



  #creates a league stub from one of the data items downloaded with the
  #get_leagues_stub_data_list function
  def self.get_league_stub(stub_data)
    return Bvt::LeagueStub.new(stub_data[0], stub_data[1])
  end

end
