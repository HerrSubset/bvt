# represents a federation. It holds several leagues.
class Bvt::Federation
  # constructor
  def initialize(name, loader = nil, full_load = false)
    @name = name
    @loader = loader
    @leagues = []
    @league_names = nil

    if full_load
      load_all

    else
      partial_load
    end
  end

  # getters
  attr_reader :name
  attr_reader :leagues

  # loads all leagues and its games belonging to a federation into memory
  def load_all
    @leagues = @loader.load unless @loader.nil?
  end

  # load the league names belonging to this federation. The leagues themselves
  # can be loaded later
  def partial_load
    if @loader
      names = @loader.get_league_names
      @league_names = names unless names.empty?
    end
  end

  # add league to this federation
  def add_league(league)
    if league.class == Bvt::League && ! @leagues.include?(league)
      @leagues.push(league)
    end
  end

  # get an array with all the names of all the leagues
  def get_league_names
    res = []

    if @league_names
      # league names were downloaded before
      @league_names.each do |l|
        res.push(l.name)
      end

    else
      # league names were not downloaded, extract them from the league objects
      @leagues.each do |l|
        res.push(l.name)
      end
    end

    res
  end

  # get the league with the given name. Try to load it dynamically if it's not
  # in the league_list array.
  def get_league(name)
    res = nil

    @leagues.each do |l|
      res = l if l.name == name
    end

    # load league if it didn't exist yet, but it's in the league_names array
    if !res && @league_names
      stub = nil
      @league_names.each { |l| stub = l if l.name == name }

      league = @loader.load_league(stub)

      if league
        res = league
        @leagues.push(league)
      end
    end

    res
  end
end # end Federation class
