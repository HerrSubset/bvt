class Bvt::Federation

  #constructor
  def initialize(name, loader = nil, full_load = true)
    @name = name
    @loader = loader
    @leagues = Array.new
    @league_names = nil

    if full_load
      load_all

    else
      partial_load
    end
  end



  #getters
  attr_reader :name
  attr_reader :leagues



  #loads all leagues and its games belonging to a federation into memory
  def load_all
    @leagues = @loader.load if @loader != nil
  end



  #load the league names belonging to this federation. The leagues themselves
  #can be loaded later
  def partial_load
    if @loader
      names = @loader.get_league_names
      @league_names = names if names.length > 0
    end
  end



  #add league to this federation
  def add_league(league)
    if league.class == Bvt::League && ! @leagues.include?(league)
      @leagues.push(league)
    end
  end



  #get an array with all the names of all the leagues
  def get_league_names
    res = Array.new


    if @league_names
      #league names were downloaded before
      res = @league_names

    else
      #league names were not downloaded, extract them from the league objects
      @leagues.each do |l|
        res.push(l.name)
      end
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
