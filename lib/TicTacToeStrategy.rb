class TicTacToeStrategy
  def initialize( board, player )
    @board = board
    @player = player
  end

  def calculate_next_move
    look_for_winning_move( @player ) \
      || look_for_blocking_move \
      || look_for_center_move \
      || look_for_opponent_corner_play \
      || look_for_fork( @player ) \
      || look_for_opponent_fork \
      || next_move
  end
  
  def look_for_winning_move( player )
    (0..2).each do |i|
      # Search rows
      row = @board.get_row(i)
      if row.has_winning_move?( player )
        return row.get_winning_move
      end

      # Search columns
      col = @board.get_col(i)
      if col.has_winning_move?( player )
        return col.get_winning_move
      end
    end

    # Search diagonally
    [ @board.get_diagonal_top_left, @board.get_diagonal_top_right ].each do |diagonal|
      if diagonal.has_winning_move?( player )
        return diagonal.get_winning_move
      end
    end

    return false
  end

  def look_for_blocking_move
    look_for_winning_move( _other_player )
  end

  def look_for_center_move
    @board.is_free?( 1, 1 ) ? { row: 1, column: 1 } : false
  end

  # If opponent is playing corners, force a them to move into a position that doesn't play into their strategy by
  # setting up for a winning move. Essentially a defensive winning move that the opponent will be forced to block and
  # veers them from their strategy.
  def look_for_opponent_corner_play
    Board.corner_pairs.each do |pair|
      if @board.is_played?( pair[0][0], pair[0][1], _other_player ) \
          && @board.is_played?( pair[1][0], pair[1][1], _other_player )
        if @board.is_played?( 1, 1, @player )
          Board.middle_exteriors.each do |me_pair|
            return { row: me_pair[0], column: me_pair[1] } if !@board.is_played?( me_pair[0], me_pair[1] )
          end
        end
      end
    end
    return false
  end

  def look_for_fork( player )
    Board.corner_pairs.each do |pair|
      if @board.is_played?( pair[0][0], pair[0][1], player ) \
          && !@board.is_played?( pair[1][0], pair[1][1] )
        return { row: pair[1][0], column: pair[1][1] }
      end
      if @board.is_played?( pair[1][0], pair[1][1], player ) \
          && !@board.is_played?( pair[0][0], pair[0][1] )
        return { row: pair[0][0], column: pair[0][1] }
      end
    end
    return false
  end

  def look_for_opponent_fork
    look_for_fork( _other_player )
  end

  def next_move
    Board.corners.each do |c|
      if @board.is_free?( c[0], c[1] )
        return { row: c[0], column: c[1] }
      end
    end

    #random
    (0..2).each do |i|
      (0..2).each do |j|
        return { row: i, column: j } if @board.is_free?( i, j )
      end
    end

    return false
  end

  private
  def _other_player
    @player == 'o' ? 'x' : 'o'
  end
end