require "rspec"
require_relative "linear_regression"

RSpec.describe LinearRegression do
  context "with an exactly linear dataset" do
    let(:rows) { [[0.0], [1.0], [2.0], [3.0], [4.0]] }
    let(:targets) { rows.map { |row| (2.0 * row.first) + 1.0 } }

    describe ".normal_equation" do
      it "recovers the true bias and weight" do
        bias, weight = described_class.normal_equation(rows, targets)

        expect(bias).to be_within(1e-6).of(1.0)
        expect(weight).to be_within(1e-6).of(2.0)
      end
    end

    describe "gradient descent" do
      it "fits scaled features with an R² greater than 0.999" do
        scaled_rows, = standardize(rows)
        model = described_class.new(
          learning_rate: 0.1,
          iterations: 5_000
        ).fit(scaled_rows, targets)

        predictions = model.predict(scaled_rows)

        expect(RegressionMetrics.r2(predictions, targets)).to be > 0.999
      end
    end
  end

  describe ".normal_equation with ridge regularisation" do
    let(:rows) do
      [
        [1.0, 1.0],
        [2.0, 1.5],
        [3.0, 2.5],
        [4.0, 4.0],
        [5.0, 5.5]
      ]
    end
    let(:targets) { [4.0, 6.5, 10.0, 15.0, 20.5] }

    it "produces a smaller feature-weight norm when lambda is 100" do
      unregularized = described_class.normal_equation(rows, targets, lambda: 0.0)
      regularized = described_class.normal_equation(rows, targets, lambda: 100.0)

      unregularized_norm = Math.sqrt(unregularized.drop(1).sum { |weight| weight**2 })
      regularized_norm = Math.sqrt(regularized.drop(1).sum { |weight| weight**2 })

      expect(regularized_norm).to be < unregularized_norm
    end
  end

  describe "#predict" do
    it "returns a finite raw numeric prediction for a held-out row" do
      training_rows = [[0.0], [1.0], [2.0], [3.0]]
      targets = training_rows.map { |row| (2.0 * row.first) + 1.0 }
      scaled_rows, means, stds = standardize(training_rows)

      model = described_class.new(
        learning_rate: 0.1,
        iterations: 5_000
      ).fit(scaled_rows, targets)

      held_out_row = [4.0]
      scaled_held_out_row = held_out_row.each_index.map do |index|
        (held_out_row[index] - means[index]) / stds[index]
      end
      prediction = model.predict([scaled_held_out_row]).first

      expect(prediction).to be_a(Numeric)
      expect(prediction).to be_finite
      expect(prediction.nan?).to be(false)
    end
  end
end
