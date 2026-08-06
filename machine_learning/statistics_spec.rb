require "rspec"
require_relative "statistics"

RSpec.describe Statistics do
  describe ".standardize" do
    it "returns scaled rows and the statistics used to scale them" do
      rows = [[1.0, 10.0], [2.0, 20.0], [3.0, 30.0]]

      scaled_rows, means, standard_deviations = described_class.standardize(rows)

      expect(scaled_rows[0]).to all(be_within(1e-12).of(-Math.sqrt(1.5)))
      expect(scaled_rows[1]).to all(be_within(1e-12).of(0.0))
      expect(scaled_rows[2]).to all(be_within(1e-12).of(Math.sqrt(1.5)))
      expect(means).to eq([2.0, 20.0])
      expect(standard_deviations).to eq([Math.sqrt(2.0 / 3), Math.sqrt(200.0 / 3)])
    end
  end
end
