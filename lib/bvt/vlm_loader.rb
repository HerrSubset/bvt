
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



end
