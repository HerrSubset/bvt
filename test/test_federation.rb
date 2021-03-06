require "minitest/autorun"
require "bvt"

class FederationTest < Minitest::Test
  def test_constructor
    f1 = Bvt::Federation.new("f1")
    assert_equal(f1.name, "f1")
    assert_equal(f1.leagues.class, Array)
    assert_equal(f1.leagues.length, 0)

    f2 = Bvt::Federation.new("f2", nil)
    assert_equal(f2.leagues.class, Array)
    assert_equal(f2.leagues.length, 0)

    f3 = Bvt::Federation.new("f3")
    assert_equal(f3.leagues.class, Array)
    assert_equal(f3.leagues.length, 0)
  end


  def test_add_league
    l1 = Bvt::League.new("a")
    l2 = Bvt::League.new("b")
    l3 = Bvt::League.new("a")
    fed = Bvt::Federation.new("vvb")

    #add two leagues
    fed.add_league(l1)
    assert_equal(fed.leagues.length, 1)

    fed.add_league(l2)
    assert_equal(fed.leagues.length, 2)

    #this league should not be added
    fed.add_league(l3)
    assert_equal(fed.leagues.length, 2)
  end


  #when a league is loaded dynamically, it should be stored in memory
  def test_dynamic_loading_stores_league
    fed = Bvt::Federation.new("KOVV", Bvt::KovvLoader, false)
    names = fed.get_league_names

    assert(names.length > 0, "names should be downloaded on partial load")

    name = names[0]
    league = fed.get_league(name)

    assert(league.name == name, "name of downloaded league should be equal to the league requested")
    assert(fed.leagues.include?(league), "make sure league is added to the federation")
  end
end
