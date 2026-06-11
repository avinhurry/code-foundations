# frozen_string_literal: true

require "rspec"
require_relative "weather_naive_bayes_exercise"

RSpec.describe WeatherNaiveBayes do
  let(:model) { described_class.new(features: FEATURES, label: LABEL, alpha: 1.0).fit(DATA) }

  describe "Tier 1: counting" do
    describe "#prior" do
      it "calculates class priors" do
        skip "Implement in Tier 4"
      end
    end

    describe "#likelihood" do
      it "calculates conditional probabilities" do
        skip "Implement in Tier 4"
      end
    end
  end
end