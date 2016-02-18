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
end
