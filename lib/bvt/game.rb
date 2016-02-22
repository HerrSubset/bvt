class Bvt::Game
  #constructor for a game
  def initialize(id, home_team, away_team, date, home_sets = 0, away_sets = 0)
    @id = id
    @home_team = home_team
    @away_team = away_team
    @home_sets = home_sets
    @away_sets = away_sets
    @location = location
    @date = date
  end


  #getters
  attr_reader :id
  attr_reader :home_team
  attr_reader :away_team
  attr_reader :home_sets
  attr_reader :away_sets
  attr_reader :location
  attr_reader :date



  #return this game's info in a single string
  def to_s
    res = "#{@id}  #{date.strftime('%d/%m/%Y')}\t#{@home_team} - #{@away_team}"

    if @home_sets != 0 || @away_sets != 0
      res += "   #{@home_sets}-#{@away_sets}"
    end

    return res
  end


  #checks if a game has been played. This can be verified by checking if one of
  #the set scores is different from 0
  def has_been_played?
    return (@home_sets != 0) || (@away_sets != 0)
  end


  #overwrite the equality operator for the game class
  def ==(game)
    return (game.class == Bvt::Game) && (@id == game.id)
  end
end
