require_relative 'decision_tree'

class Minimax
  def initialize(cache = DecisionTree.new)
    @cache = cache
  end

  def best_move(board)
    best_score = -Float::INFINITY
    move = nil

    board.each_with_index do |cell, idx|
      next unless cell.nil?

      board[idx] = :X # AI makes a move
      score = score_board(board, 0, false) # Simulate opponent's turn
      board[idx] = nil # Undo move (backtrack)

      if score > best_score
        best_score = score
        move = idx
      end
    end

    move
  end

  private

  def score_board(board, depth, is_maximizing)
    winner = evaluate_winner(board)

    return 10 if winner == :X
    return -10 if winner == :O
    return 0 if board.none?(nil) # Draw (board is full)

    if is_maximizing
      best_score = -Float::INFINITY

      board.each_with_index do |cell, idx|
        next unless cell.nil?

        board[idx] = :X # AI's turn
        score = score_board(board, depth + 1, false)
        board[idx] = nil # Undo move

        best_score = [best_score, score].max
      end

      best_score
    else
      best_score = Float::INFINITY

      board.each_with_index do |cell, idx|
        next unless cell.nil?

        board[idx] = :O # Opponent's turn
        score = score_board(board, depth + 1, true)
        board[idx] = nil # Undo move

        best_score = [best_score, score].min
      end

      best_score
    end
  end

  def evaluate_winner(board)
    winning_combos = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ]

    winning_combos.each do |combo|
      a, b, c = combo
      values = [board[a], board[b], board[c]]

      if values.all? && values.uniq.size == 1
        return values.first # :X or :O
      end
    end

    nil # No winner yet
  end
end
