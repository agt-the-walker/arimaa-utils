#!/usr/bin/env ruby
# frozen_string_literal: true

BOARD_SIZE = 8
NB_PLAYERS = 2

def each_game
  stream = if $stdin.tty?
             game_db = `. #{File.dirname(__FILE__)}/common.sh
                        echo $GAME_DB`.chomp
             File.open(game_db)
           else
             $stdin
           end
  stream.each do |line|
    next if line.start_with?('id')  # header

    yield line.force_encoding('BINARY').split("\t")
  end
end
