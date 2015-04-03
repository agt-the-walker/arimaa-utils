#!/usr/bin/env ruby

require 'test/unit'
require_relative 'movelist'

class TestMoveList < Test::Unit::TestCase
  def setup
    unless defined?(@@move_lists)
      @@move_lists = {}
      Dir['testdata/*.txt'].sort.each do |path|
        @@move_lists[File.basename(path, '.txt').to_i] =
            MoveList.new(IO.read(path))
      end
    end
  end

  def test_plies
    expected_plies = [28, 9, 76, 75, 122, 61, 82, 134, 92]
    @@move_lists.each do |game_id, move_list|
      assert_equal(expected_plies.shift, move_list.plies, game_id)
    end
    assert_empty(expected_plies)
  end

  def test_fen_setup
    [[33, ['1g 8/8/8/8/8/8/HDRMECDH/RRRRRRCR',
           '1s rrcrrcrr/hdremrdh/8/8/8/8/HDRMECDH/RRRRRRCR']],
     [138, ['1g 8/8/8/8/8/8/HDCMECDH/RRRRRRRR',
            '1s rrrrerrr/hdcmrcdh/8/8/8/8/HDCMECDH/RRRRRRRR']]
    ].each do |game_id, fens|
      assert_equal(fens, @@move_lists[game_id].each.first(2))
    end
  end
end
