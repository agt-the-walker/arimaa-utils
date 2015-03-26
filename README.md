# Purpose

## fetch-new-games

This script downloads new archived games from
[Arimaa](http://arimaa.com/arimaa/) into `$HOME/data/Data - Arimaa/` (this
location can be changed in `common.sh`). It also builds a games database in
the same location, which will be used by the two following scripts.

## good-human-games

This script only prints good human games from the games database built by
`fetch-new-games`. Each human player should be rated at least 1800 and the game
should last 10+ moves.

## normalized-setups

This script prints normalized
[setups](http://en.wikibooks.org/wiki/Arimaa/Initial_Piece_Placement) for both
players from the games database built by `fetch-new-games`. It can also act as
a filter (see example below). By convention, the Gold elephant is always placed
on the right (from Gold's point of view).


# Requirements

* [Bash](http://www.gnu.org/software/bash/)
* [GNU Coreutils](http://www.gnu.org/software/coreutils/)
* [GNU Tar](http://www.gnu.org/software/tar/)
* [GNU Wget](http://www.gnu.org/software/wget/)
* [Lynx](http://lynx.isc.org/)
* [Ruby](http://www.ruby-lang.org/en/) 1.9.2+


# Usage

    $ export PATH=~/src/git/arimaa-utils:$PATH  # adapt accordingly

    $ fetch-new-games  # takes a while, especially the first time

    # the following command prints the most common setups in all games
    $ normalized-setups | sort | uniq -c | sort -rn | head
       6539 1w RRRDDRRR/RHCMECHR  1b RHCEMCHR/RRRDDRRR
       5445 1w RRRRRRRR/DHCMECHD  1b DHCEMCHD/RRRRRRRR
       4861 1w RRRCCRRR/RHDMEDHR  1b RHCEMCHR/RRRDDRRR
       4527 1w RRRDDRRR/RHCMECHR  1b RHDEMDHR/RRRCCRRR
       4031 1w RRRRRRRR/DHCMECHD  1b RHCEMCHR/RRRDDRRR
       3807 1w RRRCCRRR/RHDMEDHR  1b RHDEMDHR/RRRCCRRR
       3734 1w RRRRRRRR/DHCMECHD  1b RHDEMDHR/RRRCCRRR
       3460 1w RRRDDRRR/RHCMECHR  1b DHCEMCHD/RRRRRRRR
       3454 1w RRRCCRRR/RHDMEDHR  1b DHCEMCHD/RRRRRRRR
       1731 1w RRRRRRRR/DHCMECHD  1b DHCMECHD/RRRRRRRR

    # the following command prints the most common setups in good human games
    $ good-human-games | normalized-setups | sort | uniq -c | sort -rn | head
        269 1w RRRDDRRR/RHCMECHR  1b RHCEMCHR/RRRDDRRR
        184 1w RRRDDRRR/RHCMECHR  1b RHDEMDHR/RRRCCRRR
        164 1w RRRCCRRR/RHDMEDHR  1b RHCEMCHR/RRRDDRRR
        119 1w RRRCCRRR/RHDMEDHR  1b RHDEMDHR/RRRCCRRR
         75 1w RRRDDRRR/RHCMECHR  1b RHCDEDMH/RRRRRCRR
         33 1w RRRDDRRR/RHCMECHR  1b HMCEDCHR/RRRDRRRR
         32 1w RRRCDRRR/RHDMECHR  1b RHCEMCHR/RRRDDRRR
         31 1w RRRDDRRR/RHCMECHR  1b RHCEMDHR/RRRDCRRR
         31 1w RRRDDRRR/RHCMECHR  1b RHCDECMH/RRRRDRRR
         31 1w RCRDDRCR/RHRMERHR  1b RHCEMCHR/RRRDDRRR


# Limitations

`fetch-new-games` is very slow when it has to rebuild the games database. I
should probably use [SQLite](http://www.sqlite.org/) instead, as in
[Pastebin example](http://pastebin.com/BaXKz6m9).
