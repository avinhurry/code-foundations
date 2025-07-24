require_relative '../app/binary_tree'

RSpec.describe BinaryTree do
  let(:tree) do
    root = BinaryTree.new(10)
    root.insert(5)
    root.insert(15)
    root.insert(2)
    root.insert(7)
    root.insert(12)
    root.insert(17)
    root
  end
  
  describe '#in_order_traversal' do
    it 'returns values in sorted order' do
      expect(tree.in_order_traversal).to eq([2, 5, 7, 10, 12, 15, 17])
    end
  end

  describe '#in_level_traversal' do
    it 'returns values level by level from top to bottom' do
      expect(tree.in_level_traversal).to eq([10, 5, 15, 2, 7, 12, 17])
    end
  end

  describe '#insert' do
    it 'adds new values to the tree correctly' do
      new_tree = BinaryTree.new(8)
      new_tree.insert(3)
      new_tree.insert(10)

      expect(new_tree.in_order_traversal).to eq([3, 8, 10])
      expect(new_tree.in_level_traversal).to eq([8, 3, 10])
    end
  end
end
