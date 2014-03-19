class Row
  attr_accessor :cells, :moves

  def initialize( cell1, cell2, cell3, moves )
    @cells = [ cell1, cell2, cell3 ]
    @moves = moves
  end

  def self.get_row_from_board( row_number, board )
    moves = [ board.moves[row_number][0], board.moves[row_number][1], board.moves[row_number][2] ]
    Row.new( [row_number,0], [row_number,1], [row_number,2], moves )
  end

  def self.get_col_from_board( col_number, board )
    moves = [ board.moves[0][col_number], board.moves[1][col_number], board.moves[2][col_number] ]
    Row.new( [0,col_number], [1,col_number], [2,col_number], moves )
  end

  def self.get_diagonal_top_left_from_board( board )
    moves = [ board.moves[0][0], board.moves[1][1], board.moves[2][2] ]
    Row.new( [0,0], [1,1], [2,2], moves )
  end

  def self.get_diagonal_top_right_from_board( board )
    moves = [ board.moves[0][2], board.moves[1][1], board.moves[2][0] ]
    Row.new( [0,2], [1,1], [2,0], moves )
  end

  def has_winning_move?( player )
    @moves.reject{ |j| j != player }.length == 2 && @moves.include?( nil )
  end

  def get_winning_move
    if @moves.find_index( nil ) && ( has_winning_move?( 'x' ) || has_winning_move?( 'o' ) )
      cell = @cells[@moves.find_index( nil )]
      if cell
        return { row: cell[0], column: cell[1] }
      end
    end
    return false
  end

  def has_winner?
    get_winner != false
  end

  def is_full?
    @moves.reject{ |j| j.nil? }.length == 3
  end

  def get_winner
    is_full? && @moves[0] == @moves[1] && @moves[1] == @moves[2] ? @moves[0] : false
  end
end