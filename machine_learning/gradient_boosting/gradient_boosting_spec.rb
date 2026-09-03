require "rspec"
require_relative "gradient_boosting"

RSpec.describe GradientBoosting do
  let(:n_rounds) { 3 }
  let(:learning_rate) { 1.0 }
  let(:model) { described_class.new(n_rounds: n_rounds, learning_rate: learning_rate) }
  let(:xs) { [1, 2, 3, 4, 5, 6] }
  let(:ys) { [3, 4, 10, 11, 20, 21] }

  describe "#fit" do
    it "returns itself after fitting" do
      expect(model.fit(xs, ys)).to equal(model)
    end

    it "reduces the training error across boosting rounds" do
      model.fit(xs, ys)

      expect(model.rounds.last[:mse]).to be < model.rounds.first[:mse]
    end

    it "keeps the base prediction when no split is possible" do
      model.fit([1, 1], [2, 4])

      expect(model.predict(1)).to eq(3.0)
      expect(model.rounds).to have_attributes(length: 1)
    end
  end

  describe "#predict" do
    it "combines the base prediction with the stump corrections" do
      model.fit(xs, ys)

      expect(model.predict(1)).to be_within(0.001).of(4.375)
    end
  end

  describe "early stopping" do
    it "tracks the best validation round" do
      validation_xs = [2, 5, 8, 11, 14, 17, 20, 23, 26, 29]
      validation_ys = validation_xs.map do |x|
        base = (x * 1.5) + 5
        noise = [0, 0, 0, 3, -3][x % 5]
        base + noise
      end

      training_xs = [1, 4, 7, 10, 13, 16, 19, 22, 25, 28]
      training_ys = training_xs.map do |x|
        base = (x * 1.5) + 5
        noise = [0, 0, 0, 3, -3][x % 5]
        base + noise
      end

      early_stopping_model = described_class.new(n_rounds: 500, learning_rate: 0.1)
      early_stopping_model.fit(
        training_xs,
        training_ys,
        validation_xs: validation_xs,
        validation_ys: validation_ys,
        patience: 20
      )

      expect(early_stopping_model.best_round).to be_between(1, 500)
      expect(early_stopping_model.best_validation_mse).to be >= 0

      validation_predictions = validation_xs.map { |x| early_stopping_model.predict(x) }
      final_validation_mse = validation_ys.each_index.sum do |index|
        (validation_ys[index] - validation_predictions[index])**2
      end / validation_ys.length.to_f

      expect(final_validation_mse).to be_within(0.001).of(early_stopping_model.best_validation_mse)
      expect(early_stopping_model.rounds.length).to eq(early_stopping_model.best_round + 1)
    end

    it "can keep the base prediction when every stump worsens validation error" do
      early_stopping_model = described_class.new(n_rounds: 3, learning_rate: 1.0)
      early_stopping_model.fit(
        [1, 2],
        [0, 10],
        validation_xs: [1],
        validation_ys: [5],
        patience: 1
      )

      expect(early_stopping_model.best_round).to eq(0)
      expect(early_stopping_model.predict(1)).to eq(5.0)
      expect(early_stopping_model.rounds).to have_attributes(length: 1)
    end
  end
end
