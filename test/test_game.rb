require "minitest/autorun"
require "bvt"
require "date"

class GameTest < Minitest::Test

  def test_constructor
    #create game without set scores
    g1 = Bvt::Game.new(1, "home", "away", Date.new(2003, 1,1))

    assert_equal(g1.id, 1)
    assert_equal(g1.home_team, "home")
    assert_equal(g1.away_team, "away")
    assert_equal(g1.date, Date.new(2003,1,1))
    assert_equal(g1.home_sets, 0)
    assert_equal(g1.away_sets, 0)

    #create game with set scores
    g2 = Bvt::Game.new(1, "home", "away", Date.new(2003, 1,1), 3, 1)

    assert_equal(g2.id, 1)
    assert_equal(g2.home_team, "home")
    assert_equal(g2.away_team, "away")
    assert_equal(g2.date, Date.new(2003,1,1))
    assert_equal(g2.home_sets, 3)
    assert_equal(g2.away_sets, 1)
  end


  def test_to_s
    #test unplayed game
    g1 = Bvt::Game.new(1, "home", "away", Date.new(2003, 1,1))
    assert_equal(g1.to_s, "1  01/01/2003\thome - away")

    #test played game
    g2 = Bvt::Game.new(1, "away", "home", Date.new(2003, 1,1), 3, 1)
    assert_equal(g2.to_s, "1  01/01/2003\taway - home   3-1")
  end


  def test_has_been_played
    g1 = Bvt::Game.new(1, "home", "away", Date.new(2003, 1,1))
    assert(!g1.has_been_played?)

    g2 = Bvt::Game.new(1, "home", "away", Date.new(2003, 1,1), 3,0)
    assert(g2.has_been_played?)

    g3 = Bvt::Game.new(1, "home", "away", Date.new(2003, 1,1), 0, 3)
    assert(g3.has_been_played?)

    g4 = Bvt::Game.new(1, "home", "away", Date.new(2003, 1,1), 2, 3)
    assert(g4.has_been_played?)
  end


  def test_equality_operator
    g1 = Bvt::Game.new(1, "home", "away", Date.new(2003, 1,1))
    g2 = nil
    g3 = Bvt::Game.new(3, "home", "away", Date.new(2003, 1,1))
    g4 = Bvt::Game.new(1, "home", "away", Date.new(2003, 1,1))

    assert( !(g1 == g2), "g1 should not be equal to nil")
    assert( !(g1 == g3), "g1 should not be equal to g3")
    assert( g1 == g4, "g1 should be equal to g4")
  end

end
