

require "rspec"
require_relative "classification_metrics"

RSpec.describe ClassificationMetrics do
  let(:predictions) { [1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0] }
  let(:actuals)     { [1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0] }

  describe ".confusion" do
    it "counts true positives, false positives, true negatives and false negatives" do
      expect(described_class.confusion(predictions, actuals)).to eq(
        true_positives: 6,
        false_positives: 1,
        true_negatives: 7,
        false_negatives: 2
      )
    end
  end

  describe ".accuracy" do
    it "returns the proportion of predictions that were correct" do
      expect(described_class.accuracy(predictions, actuals)).to be_within(0.001).of(0.8125)
    end
  end

  describe ".precision" do
    it "returns the proportion of positive predictions that were actually positive" do
      expect(described_class.precision(predictions, actuals)).to be_within(0.001).of(0.857)
    end
  end

  describe ".recall" do
    it "returns the proportion of actual positives that were correctly identified" do
      expect(described_class.recall(predictions, actuals)).to be_within(0.001).of(0.75)
    end
  end

  describe ".f1" do
    it "balances precision and recall" do
      expect(described_class.f1(predictions, actuals)).to be_within(0.001).of(0.8)
    end
  end

  describe ".auc" do
    it "returns 1.0 when every positive is ranked above every negative" do
      probabilities = [0.95, 0.9, 0.8, 0.2, 0.1, 0.05]
      labels = [1, 1, 1, 0, 0, 0]

      expect(described_class.auc(probabilities, labels)).to eq(1.0)
    end
  end
end