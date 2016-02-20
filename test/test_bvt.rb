require 'minitest/autorun'
require "bvt"


class BvtTest < Minitest::Test

  def test_correct_input_gives_federation
    fed = Bvt.load_federation("vvb")

    assert_equal(fed.class, Bvt::Federation)
  end


  def test_incorrect_input_gives_nil
    fed = Bvt.load_federation("non-existent federation")

    assert_equal(fed, nil)
  end
end
