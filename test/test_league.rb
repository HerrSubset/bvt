require "minitest/autorun"
require "bvt"

class LeagueTest < Minitest::Test

  def test_constructor
    league = Bvt::League.new("a")
    assert_equal(league.name, "a")
  end


  def test_add_game
    league = Bvt::League.new("a")
    g1 = Bvt::Game.new(1, "a", "b", Date.new(2003,1,1))
    g2 = Bvt::Game.new(2, "a", "b", Date.new(2003,1,1))
    g3 = Bvt::Game.new(1, "b", "a", Date.new(2003,1,1))

    #add some games
    league.add_game(g1)
    assert_equal(league.games.include?(g1), true)
    assert_equal(league.games.length, 1)

    league.add_game(g2)
    assert_equal(league.games.include?(g2), true)
    assert_equal(league.games.length, 2)

    #this game should not be added
    league.add_game(g3)
    assert_equal(league.games.include?(g3), true)
    assert_equal(league.games.length, 2)
  end



  def test_get_teams
    league = Bvt::League.new("a")
    g1 = Bvt::Game.new(1, "a", "b", Date.new(2003,1,1))
    g2 = Bvt::Game.new(2, "c", "d", Date.new(2003,1,1))
    g3 = Bvt::Game.new(3, "b", "d", Date.new(2003,1,1))
    league.add_game(g1)
    league.add_game(g2)
    league.add_game(g3)

    teams = league.get_teams

    assert(teams.include?("a"), "a should be added to the team list")
    assert(teams.include?("b"), "b should be added to the team list")
    assert(teams.include?("c"), "c should be added to the team list")
    assert(teams.include?("d"), "d should be added to the team list")
    assert_equal(teams.length, 4, "team length should be 4")
  end


  def test_get_team_games
    league = Bvt::League.new("a")
    g1 = Bvt::Game.new(1, "a", "b", Date.new(2003,1,1))
    g2 = Bvt::Game.new(2, "c", "d", Date.new(2003,1,1))
    g3 = Bvt::Game.new(3, "b", "d", Date.new(2003,1,1))
    league.add_game(g1)
    league.add_game(g2)
    league.add_game(g3)

    #try valid scenarios
    games_a = league.get_team_games("a")
    assert_equal(games_a.length, 1, "a should have one game")
    assert_equal(games_a[0].id, 1, "a's game should have id 1")

    games_b = league.get_team_games("b")
    assert_equal(games_b.length, 2, "b should have 2 games")
    assert(games_b.include?(g1), "game 1 should be in b's game list")
    assert(games_b.include?(g3), "game 3 should be in b's game list")

    #try invalid scenario
    games = league.get_team_games("f")
    assert_equal(games.length, 0)
  end




  def test_equality_operator
    l1 = Bvt::League.new("a")
    l2 = Bvt::League.new("b")
    l3 = Bvt::League.new("a")

    assert( !(l1 == l2), "league 1 and 2 should be different")
    assert( l1 == l3, "league 1 and 3 should be the same")
  end


end
