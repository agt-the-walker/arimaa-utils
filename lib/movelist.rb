#!/usr/bin/env ruby

class MoveList
  BOARD_SIZE = 8
  COLUMN_RANGE = Range.new('a', ('a'.ord + BOARD_SIZE).chr, true)
  ROW_RANGE = Range.new(1.to_s, BOARD_SIZE.to_s)

  def initialize(movelist)
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

    @board = {}  # key: square (for instance e4)

    @moves.each_with_index do |move, ply|
      move_number = "#{(ply + 1) / 2 + 1}#{ply.odd? ? 'g' : 's'}"

      move.split(' ').each do |step|
        piece = step[0]
        square = step[1..2]
        if ply < 2  # initial position setup
          @board[square] = piece
        elsif step[3] == 'x'  # piece capture
          @board.delete(square)
        else  # piece move
          dest_column = case step[3]
                          when 'e' then (square[0].ord + 1).chr
                          when 'w' then (square[0].ord - 1).chr
                          else square[0]
                        end
          dest_row = case step[3]
                       when 'n' then (square[1].ord + 1).chr
                       when 's' then (square[1].ord - 1).chr
                       else square[1]
                     end
          @board[dest_column + dest_row] = piece
          @board.delete(square)
        end
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
