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
    expected_plies = [28, 9, 76, 75, 122, 61, 109, 82, 134, 92, 17]
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
      assert_equal(fens, @@move_lists[game_id].each.first(NB_PLAYERS))
    end
  end

  def test_fen_position
    [[2077, 76, '39g 1r5r/1dhr2rR/1H1Rr1dE/3e2R1/8/3R1hcR/5RDr/4r1DR'],
     [3917, 75, '38s 1r3R1r/1Dr3r1/r7/RHeE1H2/r7/R3r3/3R1MC1/2R2hRR'],
     [72330, 69, '35s 1r3rrr/r1r1cdhr/dH1E1m2/2hD4/3e4/RD4H1/r1CcMC1R/RRRR2RR'],
     [87015, 55, '28s rrr2rr1/2cdcd1r/3h2r1/8/HDE5/1r2e3/RRCD2C1/1RR2RRR'],
     [90687, 17, '9s rcrrrr1r/h4r1d/8/3E4/1d1m2c1/1H1Me1D1/1DCR1CRH/RRR1RRR1'],
    ].each do |game_id, ply, fen|  # first ply is 1 not 0
      assert_equal(fen, @@move_lists[game_id].each.drop(ply - 1).first)
    end
  end

  def test_fen_skip_duplicates
    game_id = 72330
    fens = @@move_lists[game_id].each.to_a
    unique_fens = @@move_lists[game_id].each(:skip_duplicates => true).to_a

    assert_equal(fens.size, unique_fens.size)

    duplicate_fens = [
      '8g rrr2rrr/1dcc1d1r/rh1E1mh1/1He5/8/3D1MH1/R1C1DC1R/RRR2RRR',
      '8s rrr2rrr/1dc2d1r/rh1E1mh1/1Hec4/8/3D1MH1/R1C1DC1R/RRR2RRR',
      '12g rrr2rrr/1dc1cd1r/rh1E1mh1/8/He6/1DM3H1/R1C1DC1R/RRR2RRR',
      '12s rrr2rrr/1dc1cd1r/rh1E1mh1/1H6/1e6/1DM3H1/R1C1DC1R/RRR2RRR',
      '14g rrr2rrr/1dc1cd1r/rh1E1mh1/2eH4/8/1DM3H1/R1C1DC1R/RRR2RRR',
      '14s rrr2rrr/1dc1cd1r/rh1E1mh1/1He5/8/1DM3H1/R1C1DC1R/RRR2RRR',
      '27g rrr2rrr/1dc1cdhr/Hh1E2m1/8/De6/r2D2MH/R1C2C1R/RRR2RRR',
      '27s rrr2rrr/1dc1cdhr/Hh1E2m1/8/1e6/Dr1D2MH/R1C2C1R/RRR2RRR',
      '35g 1r3rrr/r1r1cdhr/dH1E1m2/2hD4/3e4/RD4H1/r1C1MC1R/RRRcR1RR',
      '35s 1r3rrr/r1r1cdhr/dH1E1m2/2hD4/3e4/RD4H1/r1CcMC1R/RRRR2RR',
    ]

    assert_equal(duplicate_fens, fens - unique_fens)
    assert_equal(fens.size - duplicate_fens.size, unique_fens.compact.size)
  end
end
