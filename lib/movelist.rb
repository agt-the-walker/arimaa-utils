#!/usr/bin/env ruby

class MoveList
  attr_reader :plies

  def initialize(movelist)
    @plies = movelist.scan('\n').length
  end
end
