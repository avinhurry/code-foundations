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

    it 'balances left-right (Case 2 and Case 3)' do
      tree.insert(10)
      tree.insert(5)
      tree.insert(8)

      # Inserting 10, 5, 8 creates a left-right (zig-zag) shape:
      #
      #        10 (black)
      #        /
      #      5 (red)
      #        \
      #         8 (red)
      #
      # This violates red-black rules (red child of red parent),
      # so the tree performs:
      # - Case 2: rotate left at 5 -> 8 moves up
      # - Case 3: rotate right at 10 -> 8 becomes the new root
      #
      # Final balanced structure:
      #
      #        8 (black)
      #       /   \
      #     5      10 (both red)
      #
      # This tests all logic in the else clause of #fix_insert.


      expect(tree.root.value).to eq(8)
      expect(tree.root.colour).to eq(:black)

      expect(tree.root.left.value).to eq(5)
      expect(tree.root.left.colour).to eq(:red)

      expect(tree.root.right.value).to eq(10)
      expect(tree.root.right.colour).to eq(:red)
    end

    it 'balances right-left (Case 2 and Case 3)' do
      tree.insert(10)
      tree.insert(15)
      tree.insert(12)


      # Inserting 10, 15, 12 creates a right-left (zig-zag) shape:
      #
      #        10 (black)
      #           \
      #           15 (red)
      #          /
      #        12 (red)
      #
      # This violates red-black rules (red child of red parent),
      # so the tree performs:
      # - Case 2: rotate right at 15 -> 12 moves up
      # - Case 3: rotate left at 10 -> 12 becomes the new root
      #
      # Final balanced structure:
      #
      #        12 (black)
      #       /   \
      #     10     15 (both red)
      #     
      #  This tests all logic in the else clause of #fix_insert,


      expect(tree.root.value).to eq(12)
      expect(tree.root.colour).to eq(:black)

      expect(tree.root.left.value).to eq(10)
      expect(tree.root.left.colour).to eq(:red)

      expect(tree.root.right.value).to eq(15)
      expect(tree.root.right.colour).to eq(:red)
    end
  end
end
