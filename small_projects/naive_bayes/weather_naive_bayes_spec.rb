# frozen_string_literal: true

require_relative "weather_naive_bayes_exercise"

RSpec.describe WeatherNaiveBayes do
  let(:model) { described_class.new(features: FEATURES, label: LABEL, alpha: 1.0).fit(DATA) }
  let(:unsmoothed_model) { described_class.new(features: FEATURES, label: LABEL, alpha: 0.0).fit(DATA) }

  describe "Tier 1: counting" do
    describe "#prior" do
      it "calculates the yes prior" do
        expect(model.prior("yes")).to be_within(0.0001).of(0.6429)
      end

      it "calculates the no prior" do
        expect(model.prior("no")).to be_within(0.0001).of(0.3571)
      end
    end

    describe "#likelihood" do
      it "calculates an unsmoothed likelihood" do
        expect(unsmoothed_model.likelihood(:outlook, "sunny", "no")).to be_within(0.0001).of(0.6)
      end

      it "calculates another unsmoothed likelihood" do
        expect(unsmoothed_model.likelihood(:temp, "cool", "yes")).to be_within(0.0001).of(0.3333)
      end

      it "calculates a smoothed likelihood" do
        expect(model.likelihood(:outlook, "overcast", "no")).to be_within(0.0001).of(0.125)
      end
    end
  end

  describe "Tier 2: prediction" do
    describe "#predict_probability" do
      it "calculates probabilities without smoothing" do
        probabilities = unsmoothed_model.predict_probability(TEST_1)

        expect(probabilities["yes"]).to be_within(0.0001).of(0.2046)
        expect(probabilities["no"]).to be_within(0.0001).of(0.7954)
      end

      it "demonstrates the zero-frequency bug without smoothing" do
        probabilities = unsmoothed_model.predict_probability(TEST_2)

        # The zero-frequency bug: "overcast" never appears in the "no" class,
        # so the probability of "no" becomes 0 without smoothing.
        expect(probabilities["yes"]).to eq(1.0)
        expect(probabilities["no"]).to eq(0.0)
      end
    end
  end

  describe "Tier 3: log-space prediction" do
    describe "#log_score" do
      it "calculates a log score for the yes class" do
        expect(model.log_score(TEST_1, "yes")).to be_within(0.0001).of(-4.9499)
      end

      it "calculates a log score for the no class" do
        expect(model.log_score(TEST_1, "no")).to be_within(0.0001).of(-4.0051)
      end
    end

    describe "#predict_probability_log" do
      it "calculates probabilities using log-space" do
        probabilities = model.predict_probability_log(TEST_1)

        expect(probabilities["yes"]).to be_within(0.0001).of(0.2799)
        expect(probabilities["no"]).to be_within(0.0001).of(0.7201)
      end

      it "fixes the zero-frequency bug with smoothing" do
        probabilities = model.predict_probability_log(TEST_2)

        expect(probabilities["yes"]).to be_within(0.0001).of(0.9566)
        expect(probabilities["no"]).to be_within(0.0001).of(0.0434)
      end

      it "returns probabilities that sum to 1" do
        probabilities = model.predict_probability_log(TEST_1)

        expect(probabilities.values.sum).to be_within(0.0001).of(1.0)
      end
    end

    describe "#predict" do
      it "predicts no for TEST_1" do
        expect(model.predict(TEST_1)).to eq("no")
      end

      it "predicts yes for TEST_2" do
        expect(model.predict(TEST_2)).to eq("yes")
      end
    end
  end
end