class Board
  attr_accessor :moves
  def initialize( moves = '' )
    @moves = [ [], [], [] ]
    unless moves.nil? || moves.empty?
      i = 0
      moves = moves.split('')
      (0..2).each do |row|
        (0..2).each do |col|
          @moves[row].push( moves[i] == '_' ? nil : moves[i] )
          i = i + 1
        end
      end
    end
  end

  def add_move( row, column, player )
    @moves[row][column] = player
  end

  def get_row( index )
    Row.get_row_from_board( index, self )
  end

  def get_col( index )
    Row.get_col_from_board( index, self )
  end

  def get_pos( row, column )
    @moves[row][column]
  end

  def get_diagonal_top_left
    Row.get_diagonal_top_left_from_board( self )
  end

  def get_diagonal_top_right
    Row.get_diagonal_top_right_from_board( self )
  end

  def is_played?( row, col, player = nil )
    player ? moves[row][col] == player : !moves[row][col].nil?
  end

  def is_free?( row, col )
    moves[row][col].nil?
  end

  def get_winner
    row = get_winning_row
    row ? get_pos( row[0][:row], row[0][:column] ) : false
  end

  def get_winning_row
    (0..2).each do |i|
      return [ { row: i, column: 0 }, { row: i, column: 1 }, { row: i, column: 2 } ] if self.get_row(i).has_winner?
      return [ { row: 0, column: i }, { row: 1, column: i }, { row: 2, column: i } ] if self.get_col(i).has_winner?
    end

    return [ { row: 0, column: 0 }, { row: 1, column: 1 }, { row: 2, column: 2 } ] if self.get_diagonal_top_left.has_winner?
    return [ { row: 0, column: 2 }, { row: 1, column: 1 }, { row: 2, column: 0 } ] if self.get_diagonal_top_right.has_winner?

    false
  end

  def is_it_a_draw?
    !get_winner && self.get_row(0).is_full? && self.get_row(1).is_full? && self.get_row(2).is_full?
  end

  def self.corners
    [ [0,0], [0,2], [2,0], [2,2] ]
  end

  def self.corner_pairs
    [ [ [0,0], [2,2] ], [ [0,2], [2,0] ] ]
  end

  def self.middle_exteriors
    [ [0,1], [1,2], [2,1], [1,0] ]
  end
end