#!/usr/bin/env ruby

class MoveList
  BOARD_SIZE = 8
  COLUMN_RANGE = Range.new('a', ('a'.ord + BOARD_SIZE).chr, true)
  ROW_RANGE = Range.new(1.to_s, BOARD_SIZE.to_s)

  def initialize(movelist)
    @board = {}  # key: square (for instance e4)

    @moves = []
    movelist.split('\n').each do |move|
      if move.end_with?('takeback')
        @moves.pop
      else
        @moves << move.sub(/^\w+\s+/, '')  # remove first word (move number)
      end
    end
    @moves.pop  # movelist typically ends with 39w or 50b, which can be ignored
  end

  def plies
    @moves.size
  end

  def each
    # http://blog.arkency.com/2014/01/ruby-to-enum-for-enumerator/
    return enum_for(:each) unless block_given?

    @moves.each_with_index do |move, ply|
      move_number = "#{(ply + 1) / 2 + 1}#{ply.odd? ? 'g' : 's'}"
      move.split(' ').each do |step|
        @board[step[1..2]] = step[0]
      end
      yield "#{move_number} #{fen}"
    end
  end

private

  def fen
    ROW_RANGE.collect do |row|
      buffer = ''
      empty_nb = 0

      COLUMN_RANGE.each do |column|
        if piece = @board[column + row]
          if empty_nb > 0
            buffer << empty_nb.to_s
            empty_nb = 0
          end
          buffer << piece
        else
          empty_nb += 1
        end
      end

      if empty_nb > 0
        buffer << empty_nb.to_s
      end

      buffer
    end.reverse.join('/')
  end
end
