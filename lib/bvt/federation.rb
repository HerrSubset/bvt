class Bvt::Federation

  #constructor
  def initialize(name, leagues = Array.new)
    @name = name
    @leagues = leagues
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

end #end Federation class
