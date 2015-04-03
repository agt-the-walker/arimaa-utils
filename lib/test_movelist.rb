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
    expected_plies = [28, 9, 76, 75, 122, 71, 61, 109, 78, 82, 134, 92, 17]
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
    [[2077, '39g 1r5r/1dhr2rR/1H1Rr1dE/3e2R1/8/3R1hcR/5RDr/4r1DR'],
     [3917, '38s 1r3R1r/1Dr3r1/r7/RHeE1H2/r7/R3r3/3R1MC1/2R2hRR'],

     # row 1 symmetrical
     [25021, '2s rrrddrrr/rhcemchr/8/8/3E4/6H1/CMDH1D1C/RRRRRRRR',
             '2s rrrddrrr/rhcmechr/8/8/4E3/1H6/C1D1HDMC/RRRRRRRR'],

     # rows 1 and 2 symmetrical
     [40260, '25s 3crch1/1rrrrHrr/3EdMHr/dhmReRRR/RDC1C3/RD6/2R2R2/8',
             '25s 1hcrc3/rrHrrrr1/rHMdE3/RRReRmhd/3C1CDR/6DR/2R2R2/8'],

     # completely symmetrical
     [75005, '40g rrrrrrrr/8/8/8/8/8/2d2d2/8'],

     # row 1 symmetrical
     [83846, '14s 1r4rr/rrc1cdr1/1hr3h1/2Rr4/3e4/1M1E1H2/1Cm1HC1R/RRRDDRRR'],

     [87015, '28s rrr2rr1/2cdcd1r/3h2r1/8/HDE5/1r2e3/RRCD2C1/1RR2RRR'],
     [90687, '9s rcrrrr1r/h4r1d/8/3E4/1d1m2c1/1H1Me1D1/1DCR1CRH/RRR1RRR1',
             '9s r1rrrrcr/d1r4h/8/4E3/1c2m1d1/1D1eM1H1/HRC1RCD1/1RRR1RRR'],
    ].each do |game_id, fen, normalized_fen|
      move_header = fen.split(' ').first
      assert_equal([fen], @@move_lists[game_id].each.grep(/^#{move_header} /))
      assert_equal([normalized_fen || fen],
       @@move_lists[game_id].each(:normalize => true).grep(/^#{move_header} /))
    end
  end

  def test_fen_skip_duplicates
    [[40260, ['32s 3crch1/2rrrHrr/r2EdMHr/ChmReRRR/dRD1C3/RD6/R6R/8',
              '33s 3crch1/2rrrHrr/r2EdMHr/ChmReRRR/dRD1C3/RD6/R3R3/8',
              '34g 3crch1/2rrrHrr/r2EdMHr/ChmReRRR/dR2C3/RDD5/R3R3/8',
              '35s 3crch1/2rrrHrr/r2EdMHr/ChmReRRR/dRD1C3/RD6/RR6/8',
              '36g 3crch1/2rrrHrr/r2EdMHr/ChmReRRR/dR2C3/RDD5/RR6/8',
              '36s 3crch1/2rrrHrr/r2EdMHr/ChmReRRR/dRD1C3/RD6/RR6/8']],
     [72330, ['8g rrr2rrr/1dcc1d1r/rh1E1mh1/1He5/8/3D1MH1/R1C1DC1R/RRR2RRR',
              '8s rrr2rrr/1dc2d1r/rh1E1mh1/1Hec4/8/3D1MH1/R1C1DC1R/RRR2RRR',
              '12g rrr2rrr/1dc1cd1r/rh1E1mh1/8/He6/1DM3H1/R1C1DC1R/RRR2RRR',
              '12s rrr2rrr/1dc1cd1r/rh1E1mh1/1H6/1e6/1DM3H1/R1C1DC1R/RRR2RRR',
              '14g rrr2rrr/1dc1cd1r/rh1E1mh1/2eH4/8/1DM3H1/R1C1DC1R/RRR2RRR',
              '14s rrr2rrr/1dc1cd1r/rh1E1mh1/1He5/8/1DM3H1/R1C1DC1R/RRR2RRR',
              '27g rrr2rrr/1dc1cdhr/Hh1E2m1/8/De6/r2D2MH/R1C2C1R/RRR2RRR',
              '27s rrr2rrr/1dc1cdhr/Hh1E2m1/8/1e6/Dr1D2MH/R1C2C1R/RRR2RRR',
              '35g 1r3rrr/r1r1cdhr/dH1E1m2/2hD4/3e4/RD4H1/r1C1MC1R/RRRcR1RR',
              '35s 1r3rrr/r1r1cdhr/dH1E1m2/2hD4/3e4/RD4H1/r1CcMC1R/RRRR2RR']],
    ].each do |game_id, duplicate_fens|
      fens = @@move_lists[game_id].each.to_a
      unique_fens = @@move_lists[game_id].each(:skip_duplicates => true).to_a

      assert_equal(duplicate_fens, fens - unique_fens)
      assert_equal(fens.size - duplicate_fens.size, unique_fens.size)
    end
  end
end
