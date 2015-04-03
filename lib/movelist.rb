#!/usr/bin/env ruby

class MoveList
  attr_reader :plies

  def initialize(movelist)
    @plies = -1  # movelist typically ends with 39w or 50b, which can be ignored
    movelist.split('\n').each do |move|
      @plies += move.end_with?('takeback') ? -1 : 1
    end
  end
end
