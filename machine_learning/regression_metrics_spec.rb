require "rspec"
require_relative "regression_metrics"

RSpec.describe Metrics do
  describe ".r2" do
    it "returns 1.0 for perfect predictions" do
      ys = [2.0, 4.0, 6.0, 8.0]

      expect(described_class.r2(ys, ys)).to be_within(1e-12).of(1.0)
    end

    it "returns 0.0 when every prediction equals the target mean" do
      ys = [2.0, 4.0, 6.0, 8.0]
      mean = ys.sum / ys.length.to_f
      predictions = Array.new(ys.length, mean)

      expect(described_class.r2(predictions, ys)).to be_within(1e-12).of(0.0)
    end
  end
end
