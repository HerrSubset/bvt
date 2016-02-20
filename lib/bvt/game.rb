class Bvt::Game
  #constructor for a game
  def initialize(home_team, away_team, home_sets, away_sets,  date)
    @home_team = home_team
    @away_team = away_team
    @home_sets = home_sets
    @away_sets = away_sets
    @location = location
    @date = date
  end


  #getters
  attr_reader :home_team
  attr_reader :away_team
  attr_reader :home_sets
  attr_reader :away_sets
  attr_reader :location
  attr_reader :date



  #return this game's info in a single string
  def to_s
    res = "#{date.strftime('%d/%m/%Y')}\t#{@home_team} - #{@away_team}"

    if @home_sets != 0 || @away_sets != 0
      res += "\t#{@home_sets}-#{@away_sets}"
    end

    return res
  end
end
