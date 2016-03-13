class Bvt::League

  #constructor
  def initialize(name)
    @name = name
    @games = Array.new
  end

  #getters
  attr_reader :name
  attr_reader :games


  #add a game to the list of games
  def add_game(game)
    if game.class == Bvt::Game && !@games.include?(game)
      @games.push(game)
    end
  end


  #return an array listing all the teams in this league
  def get_teams
    res = Array.new

    @games.each do |g|
      #check if home team is in the result array
      if !res.include?(g.home_team)
        res.push(g.home_team)
      end

      #check if away team is in the result array
      if !res.include?(g.away_team)
        res.push(g.away_team)
      end
    end

    return res
  end


  #return an array with all the games belonging to a certain team
  def get_team_games(team)
    res = Array.new

    @games.each do |g|
      if team == g.home_team
        res.push(g)
      end

      if team == g.away_team
        res.push(g)
      end
    end

    return res
  end


  #create an array where each line holds a hash that represents a line in the
  #rankings table for this league
  def get_rankings
    #create tmp hash storage for all the rows in the rankings table
    row_holder = Hash.new { |hash, key| hash[key] =
            {"played" => 0, "3_points" => 0, "2_points" => 0, "1_point" => 0,
            "0_points" => 0, "won_sets" => 0, "lost_sets" => 0, "points" => 0,
            "name" => key}}

    @games.each do |g|
        if g.has_been_played?
          #add played game for both teams
          row_holder[g.home_team]["played"] += 1
          row_holder[g.away_team]["played"] += 1

          #add won sets for each team
          row_holder[g.home_team]["won_sets"] += g.home_sets
          row_holder[g.away_team]["won_sets"] += g.away_sets

          #add lost sets for each team
          row_holder[g.home_team]["lost_sets"] += g.away_sets
          row_holder[g.away_team]["lost_sets"] += g.home_sets

          #handle all different game outcomes, prepare for ugly code
          #handle 3-0 and 3-1
          if (g.home_sets == 3) && (g.away_sets < 2)
            row_holder[g.home_team]["points"] += 3
            row_holder[g.home_team]["3_points"] += 1
            row_holder[g.away_team]["0_points"] += 1

          #handle 3-2
          elsif (g.home_sets == 3) && (g.away_sets == 2)
            row_holder[g.home_team]["points"] += 2
            row_holder[g.away_team]["points"] += 1
            row_holder[g.home_team]["2_points"] += 1
            row_holder[g.away_team]["1_point"] += 1

          #handle 2-3
          elsif (g.home_sets == 2) && (g.away_sets ==3)
            row_holder[g.away_team]["points"] += 2
            row_holder[g.home_team]["points"] += 1
            row_holder[g.home_team]["1_point"] += 1
            row_holder[g.away_team]["2_points"] += 1

          #handle 0-3 and 1-3
          elsif (g.home_sets < 2) && (g.away_sets == 3)
            row_holder[g.away_team]["points"] += 3
            row_holder[g.home_team]["0_points"] += 1
            row_holder[g.away_team]["3_points"] += 1
          end
        end
    end



    #convert the row_holder hash to a sorted array
    sort_ranking(row_holder)
  end



  def sort_ranking(ranking_hash)
    res = ranking_hash.values

    res.sort! { |x,y| compare_ranking_lines(x, y)}

    return res
  end


  #sort lines first on points, then on won sets and finally on lost sets
  def compare_ranking_lines(a, b)
    res = 0

    if a["points"] < b["points"]
      res = 1

    elsif b["points"] < a["points"]
      res = -1

    else
      a_won_games = a["3_points"] + a["2_points"]
      b_won_games = b["3_points"] + b["2_points"]

      if a_won_games < b_won_games
        res = 1

      elsif b_won_games < a_won_games
        res = -1

      else
        #tied in won games, look at ratio won sets/lost sets
        a_ratio = a["won_sets"].to_f / a["lost_sets"]
        b_ratio = b["won_sets"].to_f / b["lost_sets"]

        if a_ratio < b_ratio
          res = 1
        elsif b_ratio < a_ratio
          res = -1
        end
      end
    end

    return res
  end


  #override equality operator
  def ==(league)
    res = false

    if league != nil
      res = @name == league.name
    end

    return res
  end


  #override combined comparison operator. Use the names of the leagues that
  #are being compared
  def <=>(league)
    return @name <=> league.name
  end
end
