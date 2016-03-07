class Bvt::LeagueStub

  #constructor
  def initialize(name, post_parameter = nil)
    @name = name

    if post_parameter
      @post_parameter = post_parameter

    else
      @post_parameter = name
    end
  end



  #getters
  attr_reader :post_parameter
  attr_reader :name
end
