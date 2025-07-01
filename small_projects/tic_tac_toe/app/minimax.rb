require_relative 'decision_tree'

class Minimax
  def initialize
    @cache = DecisionTree.new
  end

  def best_move(board)
    # TODO: return best position using Minimax
  end

  private

  def minimax(board, depth, is_maximizing)
    # TODO: recursive minimax scoring
  end
end
