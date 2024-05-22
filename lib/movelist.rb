#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'
require_relative 'common'

class MoveList
  COLUMN_RANGE = Range.new('a', ('a'.ord + BOARD_SIZE).chr, true)
  ROW_RANGE = Range.new(1.to_s, BOARD_SIZE.to_s)
  PECKING_ORDER = 'rcdhme'  # from weakest to strongest

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
    return enum_for(__method__, **options) unless block_given?

    @board = {}  # key: square (for instance e4)

    # piece type => number of them on the board for all players
    nb_pieces = options[:normalize] ? Hash.new(0) : nil

    visited_fens = options[:skip_duplicates] ? Set.new : nil

    @moves.each_with_index do |move, ply|
      move.split(' ').each do |step|
        square = step[1..2]
        if ply < NB_PLAYERS  # initial position setup
          piece = step[0]

          @board[square] = piece
          if options[:normalize]
            nb_pieces[piece.downcase] += 1
          end
        elsif step[3] == 'x'  # piece capture
          piece = @board.delete(square)

          if options[:normalize]
            nb_pieces[piece.downcase] -= 1
            if nb_pieces[piece.downcase] == 0  # last one was just captured
              downgrade_stronger_pieces(piece.downcase, nb_pieces)
            end
          end
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
          @board[dest_column + dest_row] = @board.delete(square)
        end
      end

      fen = "#{ply.odd? ? 'g' : 's'} #{current_fen(options[:normalize])}"
      if options[:skip_duplicates]
        if visited_fens.include?(fen)
          next
        else
          visited_fens << fen
        end
      end

      move_number = ((ply + 1) / NB_PLAYERS) + 1
      yield "#{move_number}#{fen}"
    end
  end

private

  def downgrade_stronger_pieces(piece, nb_pieces)
    nb_pieces.delete(piece)

    (PECKING_ORDER.index(piece)+1).upto(PECKING_ORDER.size-1) do |index|
      stronger_piece = PECKING_ORDER[index]
      if nb_pieces[stronger_piece]
        weaker_piece = PECKING_ORDER[index-1]
        nb_pieces[weaker_piece] = nb_pieces.delete(stronger_piece)

        @board.each do |square, piece|
          if piece.downcase == stronger_piece
            @board[square] = if piece =~ /[A-Z]/
                               weaker_piece.upcase
                             else
                               weaker_piece
                             end
          end
        end
      end
    end
  end

  def current_fen(normalize)
    normalize_cmp = 0

    ROW_RANGE.collect do |row|
      buffer = ''
      empty_nb = 0

      COLUMN_RANGE.each do |column|
        if (piece = @board[column + row])
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

      if normalize and normalize_cmp == 0
        normalize_cmp = buffer <=> buffer.reverse
      end
      normalize_cmp <= 0 ? buffer : buffer.reverse

    end.reverse.join('/')
  end
end
