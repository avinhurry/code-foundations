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

  describe "#row" do
    it "returns the correct row for index 4 in 3x3 board" do
      puzzle = NPuzzle.new([1,2,3,4,5,6,7,8,0])
      expect(puzzle.row(4)).to eq(1)
      expect(puzzle.row(0)).to eq(0)
      expect(puzzle.row(8)).to eq(2)
    end
  end

  describe "#column" do
    it "returns the correct column for index 4 in 3x3 board" do
      puzzle = NPuzzle.new([1,2,3,4,5,6,7,8,0])
      expect(puzzle.column(4)).to eq(1)
      expect(puzzle.column(0)).to eq(0)
      expect(puzzle.column(8)).to eq(2)
    end
  end

  describe "#valid_moves" do
    it "returns the correct valid moves for a blank tile in the middle" do
      puzzle = NPuzzle.new([1,2,3,4,0,5,6,7,8])
      expect(puzzle.valid_moves).to contain_exactly(:up, :down, :left, :right)
    end

    it "returns the correct valid moves for a blank tile in the top-left corner" do
      puzzle = NPuzzle.new([0,1,2,3,4,5,6,7,8])
      expect(puzzle.valid_moves).to contain_exactly(:down, :right)
    end

    it "returns the correct valid moves for a blank tile in the bottom-right corner" do
      puzzle = NPuzzle.new([1,2,3,4,5,6,7,8,0])
      expect(puzzle.valid_moves).to contain_exactly(:up, :left)
    end
  end

  describe "#apply_move!" do
    it "applies the :up move correctly" do
      puzzle = NPuzzle.new([1,2,3,4,0,5,6,7,8])
      puzzle.apply_move!(:up)
      expect(puzzle.state).to eq([1,0,3,4,2,5,6,7,8])
    end

    it "applies the :down move correctly" do
      puzzle = NPuzzle.new([1,0,3,4,2,5,6,7,8])
      puzzle.apply_move!(:down)
      expect(puzzle.state).to eq([1,2,3,4,0,5,6,7,8])
    end

    it "applies the :left move correctly" do
      puzzle = NPuzzle.new([1,2,3,4,0,5,6,7,8])
      puzzle.apply_move!(:left)
      expect(puzzle.state).to eq([1,2,3,0,4,5,6,7,8])
    end

    it "applies the :right move correctly" do
      puzzle = NPuzzle.new([1,2,3,0,4,5,6,7,8])
      puzzle.apply_move!(:right)
      expect(puzzle.state).to eq([1,2,3,4,0,5,6,7,8])
    end
  end
end