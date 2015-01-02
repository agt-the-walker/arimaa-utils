## Purpose

# fetch-new-games

This script downloads new archived games from
[Arimaa](http://arimaa.com/arimaa/) and will put them into
`$HOME/data/Data - Arimaa/` (this location can be changed in `common.sh`). It
will also build a games database, which will be used by the two following
scripts.

# good-human-games

This script only prints good human games from the games database built by
`fetch-new-games`. Each human player should be rated at least 1800 and the game
should last 10+ moves.

# normalized-setups

This script, acting as a filter, is used in conjunction with the previous one
and prints normalized
[setups](http://en.wikibooks.org/wiki/Arimaa/Initial_Piece_Placement) for both
players. By convention, the Gold elephant is always placed on the right (from
Gold's point of view).


## Requirements

* [Bash](http://www.gnu.org/software/bash/)
* [GNU Coreutils](http://www.gnu.org/software/coreutils/)
* [GNU Tar](http://www.gnu.org/software/tar/)
* [GNU Wget](http://www.gnu.org/software/wget/)
* [Lynx](http://lynx.isc.org/)
* [Ruby](http://www.ruby-lang.org/en/) 1.9.2+


## Usage

    $ export PATH=~/src/git/arimaa-utils:$PATH  # adapt accordingly

    $ fetch-new-games  # will take a while, especially the first time

    # the following command prints the most common setups in good human games
    $ good-human-games | normalized-setups | sort | uniq -c | sort -rn | head
    247 1w RRRDDRRR/RHCMECHR  1b RHCEMCHR/RRRDDRRR
    181 1w RRRDDRRR/RHCMECHR  1b RHDEMDHR/RRRCCRRR
    161 1w RRRCCRRR/RHDMEDHR  1b RHCEMCHR/RRRDDRRR
    118 1w RRRCCRRR/RHDMEDHR  1b RHDEMDHR/RRRCCRRR
     70 1w RRRDDRRR/RHCMECHR  1b RHCDEDMH/RRRRRCRR
     31 1w RCRDDRCR/RHRMERHR  1b RHCEMCHR/RRRDDRRR
     30 1w RRRDDRRR/RHCMECHR  1b HMCEDCHR/RRRDRRRR
     30 1w RRRCDRRR/RHDMECHR  1b RHCEMCHR/RRRDDRRR
     29 1w RRRDDRRR/RHCMECHR  1b RHCEMDHR/RRRDCRRR
     28 1w RRRRRRRR/DHCMECHD  1b RHCEMCHR/RRRDDRRR


## Limitations

`fetch-new-games` is very slow when it has to rebuild the games database. I
should probably use [SQLite](http://www.sqlite.org/) instead, as in
[Pastebin example](http://pastebin.com/BaXKz6m9).
