# a class to hold a league's name and the post parameter that's needed to
# retrieve those league's games from the web
class Bvt::LeagueStub
  # constructor
  def initialize(name, post_parameter = nil)
    @name = name

    if post_parameter
      @post_parameter = post_parameter

    else
      @post_parameter = name
    end
  end

  # getters
  attr_reader :post_parameter
  attr_reader :name
end
