#!/usr/bin/env ruby

require 'set'
require_relative 'common'

class MoveList
  COLUMN_RANGE = Range.new('a', ('a'.ord + BOARD_SIZE).chr, true)
  ROW_RANGE = Range.new(1.to_s, BOARD_SIZE.to_s)

  def initialize(movelist)
    @moves = []
    movelist.split('\n').each do |move|
      if move.end_with?('takeback')
        @moves.pop
      elsif move !~ /^[1-9]/  # for instance: 7b\n rc7s rc6s db6s db5s
        @moves[-1] += move
      else
        @moves << move.sub(/^\w+\s?/, '')  # remove first word (move number)
      end
    end
    @moves.pop  # movelist typically ends with 39w or 50b, which can be ignored
  end

  def plies
    @moves.size
  end

  def each(**options)
    # http://blog.arkency.com/2014/01/ruby-to-enum-for-enumerator/
    return enum_for(__method__, options) unless block_given?

    @board = {}  # key: square (for instance e4)

    visited_fens = options[:skip_duplicates] ? Set.new : nil

    @moves.each_with_index do |move, ply|
      move_number = "#{(ply + 1) / NB_PLAYERS + 1}#{ply.odd? ? 'g' : 's'}"

      move.split(' ').each do |step|
        piece = step[0]
        square = step[1..2]
        if ply < NB_PLAYERS  # initial position setup
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

      fen = current_fen
      if options[:skip_duplicates]
        if visited_fens.include?(fen)
          fen = nil
        else
          visited_fens << fen
        end
      end

      yield (fen ? "#{move_number} #{fen}" : nil)
    end
  end

private

  def current_fen
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
