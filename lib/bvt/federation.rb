class Bvt::Federation

  #constructor
  def initialize(name, loader = nil)
    @name = name
    @leagues = loader.load if loader != nil

    #make sure leagues is an array if loader was nil
    @leagues = Array.new if loader == nil
  end


  #getters
  attr_reader :name
  attr_reader :leagues


  #add league to this federation
  def add_league(league)
    if league.class == Bvt::League && ! @leagues.include?(league)
      @leagues.push(league)
    end
  end


  #get an array with all the names of all the leagues
  def get_league_names
    res = Array.new

    @leagues.each do |l|
      res.push(l.name)
    end

    return res
  end


  #get the league with the given name
  def get_league(name)
    res = nil

    @leagues.each do |l|
      res = l if l.name == name
    end

    return res
  end

end #end Federation class
