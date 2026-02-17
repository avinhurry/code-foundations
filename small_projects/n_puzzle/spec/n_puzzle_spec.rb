require_relative "../lib/n_puzzle.rb"
RSpec.describe NPuzzle do
  describe "#initialize" do
    it "sets the size correctly" do
      puzzle = NPuzzle.new([1,2,3,4,5,6,7,8,0])
      expect(puzzle.size).to eq(3)
    end
  end

  describe "#blank_index" do
    it "returns the index of the blank tile (0)" do
      puzzle = NPuzzle.new([1,2,3,4,5,6,7,8,0])
      expect(puzzle.blank_index).to eq(8)
    end

    it "returns the correct index for a different state" do
      puzzle = NPuzzle.new([1,0,2,3,4,5,6,7,8])
      expect(puzzle.blank_index).to eq(1)
    end
  end
end