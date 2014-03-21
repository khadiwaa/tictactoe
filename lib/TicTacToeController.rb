class TicTacToeController < BaseController
  def compute_move
    board = Board.new( @request.data['board'] )
    unless board.get_winner
      strategy = TicTacToeStrategy.new( board, @request.data['player'] )
      next_move = strategy.calculate_next_move
      if next_move
        board.add_move( next_move[:row], next_move[:column], @request.data['player'] )
      end
    end

    puts board.get_winning_row.inspect
    respond_with_json( { next_move: next_move, winner: board.get_winner, winning_moves: board.get_winning_row, draw: board.is_it_a_draw? } )
  end
end