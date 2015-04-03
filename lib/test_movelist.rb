#!/usr/bin/env ruby

require 'test/unit'
require_relative 'movelist'

class TestMoveList < Test::Unit::TestCase
  def setup
    unless defined?(@@move_lists)
      @@move_lists = {}
      Dir["#{File.dirname(__FILE__)}/testdata/*.txt"].sort.each do |path|
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
    [[33, ['1s 8/8/8/8/8/8/HDRMECDH/RRRRRRCR',
           '2g rrcrrcrr/hdremrdh/8/8/8/8/HDRMECDH/RRRRRRCR']],
     [138, ['1s 8/8/8/8/8/8/HDCMECDH/RRRRRRRR',
            '2g rrrrerrr/hdcmrcdh/8/8/8/8/HDCMECDH/RRRRRRRR']],
     [87015, ['1s 8/8/8/8/8/8/RHCMECHR/RDRRDRRR',
              '2g rrrdcrrr/rhcemdhr/8/8/8/8/RHCMECHR/RDRRDRRR']],
    ].each do |game_id, fens|
      assert_equal(fens, @@move_lists[game_id].each.first(2))
    end
  end

  def test_fen_position
    [[2077, 76, '39g 1r5r/1dhr2rR/1H1Rr1dE/3e2R1/8/3R1hcR/5RDr/4r1DR'],
     [3917, 75, '38s 1r3R1r/1Dr3r1/r7/RHeE1H2/r7/R3r3/3R1MC1/2R2hRR'],
     [87015, 55, '28s rrr2rr1/2cdcd1r/3h2r1/8/HDE5/1r2e3/RRCD2C1/1RR2RRR'],
    ].each do |game_id, ply, fen|  # first ply is 1 not 0
      assert_equal(fen, @@move_lists[game_id].each.drop(ply - 1).first)
    end
  end
end
