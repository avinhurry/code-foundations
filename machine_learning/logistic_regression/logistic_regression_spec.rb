require "rspec"
require_relative "../classification_metrics"
require_relative "logistic_regression"

RSpec.describe LogisticRegression do
  let(:rows) { [[0.0], [1.0], [2.0], [3.0], [4.0], [5.0]] }
  let(:targets) { [0, 0, 0, 1, 1, 1] }
  let(:scaled_rows) { standardize(rows).first }
  let(:model) { described_class.new }

  describe "#sigmoid" do
    it "returns 0.5 for zero" do
      expect(model.sigmoid(0)).to eq(0.5)
    end

    it "stays between 0 and 1 for extreme inputs" do
      expect(model.sigmoid(-20)).to be_between(0, 1).exclusive
      expect(model.sigmoid(20)).to be_between(0, 1).exclusive
    end
  end

  context "with a clearly separable dataset" do
    let(:model) do
      described_class.new(
        learning_rate: 0.1,
        iterations: 5_000
      )
    end

    it "fits the dataset with high accuracy" do
      model.fit(scaled_rows, targets)
      predictions = model.predict(scaled_rows)

      expect(ClassificationMetrics.accuracy(predictions, targets)).to be > 0.9
    end
  end

  describe "#predict" do
    let(:lower_threshold_model) do
      described_class.new(threshold: 0.3).fit(scaled_rows, targets)
    end

    let(:higher_threshold_model) do
      described_class.new(threshold: 0.7).fit(scaled_rows, targets)
    end

    it "uses the configured threshold to turn probabilities into classes" do
      lower_threshold_positives = lower_threshold_model.predict(scaled_rows).count(1)
      higher_threshold_positives = higher_threshold_model.predict(scaled_rows).count(1)

      expect(higher_threshold_positives).to be <= lower_threshold_positives
    end

    it "does not increase recall when the threshold is raised" do
      lower_recall = ClassificationMetrics.recall(lower_threshold_model.predict(scaled_rows), targets)
      higher_recall = ClassificationMetrics.recall(higher_threshold_model.predict(scaled_rows), targets)

      expect(higher_recall).to be <= lower_recall
    end
  end

  describe "L2 regularization" do
    it "produces a smaller weight norm when lambda is larger" do

      unregularized = described_class.new(lambda: 0.0).fit(scaled_rows, targets)
      regularized = described_class.new(lambda: 1.0).fit(scaled_rows, targets)

      unregularized_norm = Math.sqrt(unregularized.weights.sum { |weight| weight**2 })
      regularized_norm = Math.sqrt(regularized.weights.sum { |weight| weight**2 })

      expect(regularized_norm).to be < unregularized_norm
    end
  end
end
