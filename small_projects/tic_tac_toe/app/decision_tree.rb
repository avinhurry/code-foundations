require_relative '../../../data_structures_and_algorithms/red_black_trees/app/red_black_tree'
require_relative '../../../data_structures_and_algorithms/red_black_trees/app/red_black_node'


class DecisionTree
  def initialize
    @tree = RedBlackTree.new
  end

  def insert(key, value)
    @tree.insert(key, value)
  end

  def find(key)
    @tree.find(key)
  end
end
