require 'rspec'
require_relative '../app/red_black_tree'

RSpec.describe RedBlackTree do
  let(:tree) { RedBlackTree.new }

  describe '#insert' do
    it 'inserts the first node as the black root' do
      tree.insert(10)

      expect(tree.root.value).to eq(10)
      expect(tree.root.colour).to eq(:black)
      expect(tree.root.parent).to be_nil
    end

    it 'inserts a smaller node to the left' do
      tree.insert(10)
      tree.insert(5)

      left = tree.root.left
      expect(left.value).to eq(5)
      expect(left.colour).to eq(:red)
      expect(left.parent).to eq(tree.root)
    end

    it 'inserts a larger node to the right' do
      tree.insert(10)
      tree.insert(15)

      right = tree.root.right
      expect(right.value).to eq(15)
      expect(right.colour).to eq(:red)
      expect(right.parent).to eq(tree.root)
    end
    
    it 'inserts sibling red nodes correctly under a black root' do
      tree.insert(10) # root
      tree.insert(5) # goes left (child of root)
      tree.insert(15) # goes right  (child of root)

      expect(tree.root.colour).to eq(:black)
      expect(tree.root.left.colour).to eq(:red)
      expect(tree.root.right.colour).to eq(:red)
    end
  end
end
