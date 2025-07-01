class TicTacToe
  def initialize
    @board = Array.new(9, nil)
    @current_player = :X
  end

  WINNING_COMBOS = [
  [0, 1, 2],
  [3, 4, 5],
  [6, 7, 8],
  [0, 3, 6],
  [1, 4, 7],
  [2, 5, 8],
  [0, 4, 8],
  [2, 4, 6]
].freeze


  def print_board
    # TODO: use terminal-table eventually
  end

  def make_move(pos)
    return false unless (0..8).include?(pos) && @board[pos].nil?

    @board[pos] = @current_player
    @current_player = @current_player == :X ? :O : :X
    return true
  end

  def winner?
    WINNING_COMBOS.each do |combo|
      a, b, c = combo
      values = [@board[a], @board[b], @board[c]]

      if values.all? && values.uniq.size == 1
        return values.first  # :X or :O
      end
    end

    nil  # No winner yet
  end

  def game_over?
    winner? || available_moves.empty?
  end


  def available_moves
    @board.each_index.select { |i| @board[i].nil? }
  end
end
