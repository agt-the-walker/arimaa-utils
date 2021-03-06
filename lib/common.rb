#!/usr/bin/env ruby

BOARD_SIZE = 8
NB_PLAYERS = 2

def each_game
  stream = if STDIN.tty?
             game_db=%x{. #{File.dirname(__FILE__)}/common.sh
                        echo $GAME_DB}.chomp
             open(game_db)
           else
             STDIN
           end
  stream.each do |line|
    next if line.start_with?('id')  # header

    yield line.force_encoding('BINARY').split("\t")
  end
end
