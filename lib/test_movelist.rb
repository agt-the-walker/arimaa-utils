#!/usr/bin/env ruby

require 'test/unit'
require_relative 'movelist'

class TestMoveList < Test::Unit::TestCase
  def test_plies
    expected_plies = [122, 61, 82, 134, 92]
    Dir['testdata/*.txt'].sort.each do |path|
      assert_equal(expected_plies.shift, MoveList.new(IO.read(path)).plies,
                   path)
    end
    assert_empty(expected_plies)
  end
end
