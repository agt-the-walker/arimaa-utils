![Shell workflow](https://github.com/agt-the-walker/arimaa-utils/actions/workflows/shell.yml/badge.svg)
![Ruby workflow](https://github.com/agt-the-walker/arimaa-utils/actions/workflows/ruby.yml/badge.svg)

# Purpose

## fetch-new-games

This script downloads new archived games from
[Arimaa](http://arimaa.com/arimaa/) into `$HOME/.arimaa-utils` (this location
can be changed in `lib/common.sh`). It also builds a games database in the same
location, which will be used by the following scripts.

## good-human-games

This script only prints good human games from the games database built by
`fetch-new-games`. Each human player should be rated at least 1800 and the
game, rated, should last 10+ moves.

## normalized-setups

This script prints normalized
[setups](https://en.wikibooks.org/wiki/Arimaa/Initial_Piece_Placement) for both
players from the games database built by `fetch-new-games`. It can also act as
a filter (see example below). By convention, the Gold elephant is always placed
on the right (from Gold's point of view).

## positions

This script prints FEN positions (as described in Appendix C of [Beginning
Arimaa](http://arimaa.com/arimaa/store/beginningArimaaSC.html)) from the games
database built by `fetch-new-games`. It can also act as a filter (see example
below). It accepts the following flags:
* `--normalize` (or `-n`): print normalized positions. Vertical symmetry of the
  Arimaa board is taken into account, and so are missing piece types. For
  instance, a position where only rabbits, dogs and elephants remain will be
  normalized to a position where only rabbits, cats and dogs remain.
* `--skip_duplicates` (or `-s`): don't print repeated positions (with the same
  player to move) for a given game


# Requirements

* [Bash](https://www.gnu.org/software/bash/)
* [GNU Coreutils](https://www.gnu.org/software/coreutils/)
* [GNU Tar](https://www.gnu.org/software/tar/)
* [GNU Wget](https://www.gnu.org/software/wget/)
* [Lynx](https://lynx.invisible-island.net/)
* [Ruby](https://www.ruby-lang.org/en/) 2.7+


# Usage

    $ export PATH=~/src/git/arimaa-utils:$PATH  # adapt accordingly

    $ fetch-new-games  # takes a while, especially the first time

    # the following command prints the most common setups in all games
    $ normalized-setups | sort | uniq -c | sort -rn | head
       8161 1w RRRDDRRR/RHCMECHR  1b RHCEMCHR/RRRDDRRR
       6568 1w RRRRRRRR/DHCMECHD  1b DHCEMCHD/RRRRRRRR
       5886 1w RRRCCRRR/RHDMEDHR  1b RHCEMCHR/RRRDDRRR
       5331 1w RRRDDRRR/RHCMECHR  1b RHDEMDHR/RRRCCRRR
       5143 1w RRRRRRRR/DHCMECHD  1b RHCEMCHR/RRRDDRRR
       5011 1w RRRRRRRR/DHCMECHD  1b RHDEMDHR/RRRCCRRR
       4888 1w RRRCCRRR/RHDMEDHR  1b RHDEMDHR/RRRCCRRR
       4499 1w RRRCCRRR/RHDMEDHR  1b DHCEMCHD/RRRRRRRR
       4180 1w RRRDDRRR/RHCMECHR  1b DHCEMCHD/RRRRRRRR
       2229 1w RRRRRRRR/DHCMECHD  1b DHCMECHD/RRRRRRRR

    # number of good human games (see definition above) in the database
    $ good-human-games | sed 1d | wc -l
    4356

    # the following command prints the most common setups in good human games
    $ good-human-games | normalized-setups | sort | uniq -c | sort -rn | head
        284 1w RRRDDRRR/RHCMECHR  1b RHCEMCHR/RRRDDRRR
        193 1w RRRDDRRR/RHCMECHR  1b RHDEMDHR/RRRCCRRR
        168 1w RRRCCRRR/RHDMEDHR  1b RHCEMCHR/RRRDDRRR
        114 1w RRRCCRRR/RHDMEDHR  1b RHDEMDHR/RRRCCRRR
         64 1w RRRDDRRR/RHCMECHR  1b RHCDEDMH/RRRRRCRR
         57 1w RRRDDRRR/RHCMECHR  1b HMCEDCHR/RRRDRRRR
         44 1w RRRDDRRR/RHCMECHR  1b RHCEMDHR/RRRDCRRR
         38 1w RRRCDRRR/RHDMECHR  1b RHCEMCHR/RRRDDRRR
         36 1w RRRDDRRR/RHCMECHR  1b RHCDECMH/RRRRDRRR
         31 1w RRRRRRRR/DHCMECHD  1b RHCEMCHR/RRRDDRRR

    # print the most common Gold setups in good human games
    $ good-human-games | normalized-setups | cut -d' ' -f1-2 | \
      sort | uniq -c | sort -rn | head
       1374 1w RRRDDRRR/RHCMECHR
        654 1w RRRCCRRR/RHDMEDHR
        176 1w RRRRRRRR/DHCMECHD
        173 1w RRRCDRRR/RHDMECHR
        173 1w RCRDDRCR/RHRMERHR
        115 1w RRRRRCRR/RHCDEDMH
         63 1w RDRRDRRR/RHCMECHR
         61 1w RDRCCRDR/RHRMERHR
         54 1w RRRCCRRR/DHRMERHD
         51 1w RRRDCRRR/RHCMEDHR

    # print the most common Silver setups in good human games if Gold chooses
    # the most common setup
    $ good-human-games | normalized-setups | \
      grep -Po '(?<=^1w RRRDDRRR/RHCMECHR  ).*' | \
      sort | uniq -c | sort -rn | head
        284 1b RHCEMCHR/RRRDDRRR
        193 1b RHDEMDHR/RRRCCRRR
         64 1b RHCDEDMH/RRRRRCRR
         57 1b HMCEDCHR/RRRDRRRR
         44 1b RHCEMDHR/RRRDCRRR
         36 1b RHCDECMH/RRRRDRRR
         31 1b RHCEDCMH/RRRDRRRR
         29 1b RHREMRHR/RCRDDRCR
         27 1b DHCEMCHD/RRRRRRRR
         22 1b RMCEDCHH/RRRDRRRR

    # print the first ten positions of game 132386
    $ good-human-games | grep -w ^132386 | positions | head
    132386	1s 8/8/8/8/8/8/RHDMEDHR/RRRCCRRR
    132386	2g rrrdrrcr/hhcedrmr/8/8/8/8/RHDMEDHR/RRRCCRRR
    132386	2s rrrdrrcr/hhcedrmr/8/4E3/8/1H6/R1DM1DHR/RRRCCRRR
    132386	3g rrr1rrcr/h1cddrmr/1h6/3eE3/8/1H6/R1DM1DHR/RRRCCRRR
    132386	3s rrr1rrcr/h1cddrmr/1h6/3eE3/8/1H4H1/1RDMCDR1/RRRC1RRR
    132386	4g rrr1rrcr/2cddrmr/hh6/4E3/1e6/1H4H1/1RDMCDR1/RRRC1RRR
    132386	4s rrr1rrcr/2cddrmr/hh6/1E6/1e6/1H4H1/R1DMCDR1/RRRC1RRR
    132386	5g rrr1rrcr/2cddrmr/hh6/1E6/He6/6H1/R1DMCDR1/RRRC1RRR
    132386	5s rrr1rrcr/2cddrmr/hh6/1E6/1e6/1H4H1/R1DMCDR1/RRRC1RRR
    132386	6g rrr1rrcr/2cddrmr/hh6/1E6/He6/6H1/R1DMCDR1/RRRC1RRR

    # print the corresponding normalized positions (due to vertical symmetry)
    $ good-human-games | grep -w ^132386 | positions -n | head
    132386	1s 8/8/8/8/8/8/RHDEMDHR/RRRCCRRR
    132386	2g rcrrdrrr/rmrdechh/8/8/8/8/RHDEMDHR/RRRCCRRR
    132386	2s rrrdrrcr/hhcedrmr/8/4E3/8/1H6/R1DM1DHR/RRRCCRRR
    132386	3g rrr1rrcr/h1cddrmr/1h6/3eE3/8/1H6/R1DM1DHR/RRRCCRRR
    132386	3s rcrr1rrr/rmrddc1h/6h1/3Ee3/8/1H4H1/1RDCMDR1/RRR1CRRR
    132386	4g rcrr1rrr/rmrddc2/6hh/3E4/6e1/1H4H1/1RDCMDR1/RRR1CRRR
    132386	4s rcrr1rrr/rmrddc2/6hh/6E1/6e1/1H4H1/1RDCMD1R/RRR1CRRR
    132386	5g rcrr1rrr/rmrddc2/6hh/6E1/6eH/1H6/1RDCMD1R/RRR1CRRR
    132386	5s rcrr1rrr/rmrddc2/6hh/6E1/6e1/1H4H1/1RDCMD1R/RRR1CRRR
    132386	6g rcrr1rrr/rmrddc2/6hh/6E1/6eH/1H6/1RDCMD1R/RRR1CRRR

    # print the first ten non-repeated positions of game 132386
    $ good-human-games | grep -w ^132386 | positions -s | head
    132386	1s 8/8/8/8/8/8/RHDMEDHR/RRRCCRRR
    132386	2g rrrdrrcr/hhcedrmr/8/8/8/8/RHDMEDHR/RRRCCRRR
    132386	2s rrrdrrcr/hhcedrmr/8/4E3/8/1H6/R1DM1DHR/RRRCCRRR
    132386	3g rrr1rrcr/h1cddrmr/1h6/3eE3/8/1H6/R1DM1DHR/RRRCCRRR
    132386	3s rrr1rrcr/h1cddrmr/1h6/3eE3/8/1H4H1/1RDMCDR1/RRRC1RRR
    132386	4g rrr1rrcr/2cddrmr/hh6/4E3/1e6/1H4H1/1RDMCDR1/RRRC1RRR
    132386	4s rrr1rrcr/2cddrmr/hh6/1E6/1e6/1H4H1/R1DMCDR1/RRRC1RRR
    132386	5g rrr1rrcr/2cddrmr/hh6/1E6/He6/6H1/R1DMCDR1/RRRC1RRR
    132386	6s rrr1rrcr/2cddrmr/hh6/1E6/1e6/H2M2H1/R1D1CDR1/RRRC1RRR
    132386	7g rrr1rr1r/2cddrcr/1h4m1/hE6/8/He1M2H1/R1D1CDR1/RRRC1RRR

    # print the final position of the longest good human game
    $ good-human-games | positions | sort -k2 -rn | head -1
    53484	136g 8/5c2/1H1rE1d1/8/5De1/1C2D3/8/7r

    # print the corresponding normalized position (since camels were missing)
    $ good-human-games | grep -w ^53484 | positions -n | tail -1
    53484	136g 8/5c2/1H1rM1d1/8/5Dm1/1C2D3/8/7r


# Limitations

`fetch-new-games` is very slow when it has to rebuild the games database. I
should probably use [SQLite](https://www.sqlite.org/) instead, as in
[Pastebin example](https://pastebin.com/BaXKz6m9).
