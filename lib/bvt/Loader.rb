#a superclass for all the league loaders. Subclasses should implement dynamic
#loading by implementing following methods:
# -create_game(game_object)
# -get_league_games(game_stub)
# -get_league_stub_data_list
# -get_league_stub(league)
class Loader

  #load a league based on a parameter that has to be given to an online form
  #or API
  def self.load_league(league_stub)
    res = nil

    if league_stub
      games = get_league_games(league_stub)

      #create the league if games were Found
      if games && games.length > 0
        res = Bvt::League.new(league_stub.name)
        games.each do |g|
          res.add_game(create_game(g))
        end
      end
    end

    return res
  end



  #return an array containing the league stubs that can be used to dynamically
  #load leagues later on.
  def self.get_league_names
    res = Array.new

    doc = Nokogiri::HTML(open('http://volley-avf.be/bolt/kalenders'))
    leagues_holder = doc.css("select#comp_comp")[0]
    leagues = leagues_holder.css("option").to_a
    leagues.delete_at(0)  #first item is empty

    leagues = get_leagues_stub_data_list

    #push all league names into the res array
    leagues.each do |l|
      tmp = get_league_stub(l)
      res.push(tmp)
    end

    return res
  end



  #use the functions for dynamic loading to load the entire league at once
  def self.load
    res = Array.new
    league_stubs = get_league_names

    league_stubs.each do |s|
      league = load_league(s)
      res.push(league)
    end

    return res
  end
end
