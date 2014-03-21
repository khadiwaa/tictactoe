class Board
  attr_accessor :moves
  def initialize( moves = '' )
    @moves = [ [], [], [] ]
    unless moves.nil? || moves.empty?
      i = 0
      moves = moves.split('')
      (0..2).each do |row|
        (0..2).each do
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
      return [ rc( i, 0 ), rc( i, 1 ), rc( i, 2 ) ] if self.get_row(i).has_winner?
      return [ rc( 0, i ), rc( 1, i ), rc( 2, i ) ] if self.get_col(i).has_winner?
    end

    return [ rc( 0, 0 ), rc( 1, 1 ), rc( 2, 2 ) ] if self.get_diagonal_top_left.has_winner?
    return [ rc( 0, 2 ), rc( 1, 1 ), rc( 2, 0 ) ] if self.get_diagonal_top_right.has_winner?

    false
  end

  def is_it_a_draw?
    !get_winner && self.get_row(0).is_full? && self.get_row(1).is_full? && self.get_row(2).is_full?
  end

  def rc( row, column )
    { row: row, column: column }
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