

require "rspec"
require_relative "k_nearest_neighbours"

RSpec.describe KNearestNeighbours do
  let(:classification_data) do
    [
      [[0.5, 0.0], "A"],
      [[1.0, 0.5], "B"],
      [[0.8, 0.8], "B"],
      [[1.2, 0.0], "B"],
      [[0.0, 1.5], "A"],
      [[2.0, 2.0], "A"]
    ]
  end

  describe "#distance" do
    let(:model) { described_class.new(k: 1) }

    it "calculates Euclidean distance" do
      expect(model.distance([0.0, 0.0], [3.0, 4.0])).to eq(5.0)
    end
  end

  describe "#classify" do
    it "returns the nearest label when k is 1" do
      model = described_class.new(k: 1)

      expect(model.classify([0.0, 0.0], classification_data)).to eq("A")
    end

    it "can change the prediction when more neighbours vote" do
      model = described_class.new(k: 3)

      expect(model.classify([0.0, 0.0], classification_data)).to eq("B")
    end
  end

  describe "#regress" do
    let(:regression_data) do
      [
        [[1.0], 10.0],
        [[2.0], 15.0],
        [[4.0], 22.0],
        [[5.0], 30.0],
        [[6.0], 35.0]
      ]
    end

    it "averages the values of the nearest neighbours" do
      model = described_class.new(k: 3)

      expect(model.regress([4.5], regression_data)).to eq(29.0)
    end
  end

  describe "#weighted_classify" do
    let(:weighted_data) do
      [
        [[0.1], "A"],
        [[1.0], "B"],
        [[1.1], "B"],
        [[5.0], "A"]
      ]
    end

    it "can favour a much closer neighbour over a farther majority" do
      model = described_class.new(k: 3)

      expect(model.classify([0.0], weighted_data)).to eq("B")
      expect(model.weighted_classify([0.0], weighted_data)).to eq("A")
    end
  end
end