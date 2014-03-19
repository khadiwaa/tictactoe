class TicTacToeController < BaseController
  def compute_move
    board = Board.new( @request.data['board'] )
    next_move = TicTacToeStrategy::calculate_next_move( board, @request.data['player'] )
    if next_move
      board.add_move( next_move[:row], next_move[:column], @request.data['player'] )
    end
    puts board.get_winning_row.inspect
    respond_with_json( { next_move: next_move, winner: board.get_winner, winning_moves: board.get_winning_row, draw: board.is_it_a_draw? } )
  end
end