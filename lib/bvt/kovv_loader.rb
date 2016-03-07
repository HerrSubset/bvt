require "net/http"
require "json"


class Bvt::KovvLoader

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

  end
end
