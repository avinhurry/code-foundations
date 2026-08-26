require "rspec"
require_relative "decision_tree"
require_relative "decision_tree_data"

RSpec.describe DecisionTree do
  let(:model) { described_class.new }
  let(:rows) { DecisionTreeData::CATEGORICAL_ROWS }
  let(:features) { %i[outlook wind] }
  let(:label) { :play }

  describe "#gini" do
    it "returns 0.5 for the mixed root dataset" do
      expect(model.gini(rows, label)).to eq(0.5)
    end

    it "returns 0 for a pure group" do
      pure_rows = rows.select { |row| row[:outlook] == "sunny" }

      expect(model.gini(pure_rows, label)).to eq(0.0)
    end
  end

  describe "#gain" do
    it "shows outlook has more gain than wind" do
      expect(model.gain(rows, :outlook, label)).to eq(0.25)
      expect(model.gain(rows, :wind, label)).to eq(0.125)
    end
  end

  describe "#build_tree" do
    it "chooses outlook as the first split" do
      tree = model.build_tree(rows, features, label)

      expect(tree[:feature]).to eq(:outlook)
    end

    it "respects max depth" do
      shallow_rows = rows + [
        { outlook: "rainy", wind: "weak", play: "yes" }
      ]
      tree = model.build_tree(shallow_rows, features, label, max_depth: 1)

      expect(tree[:branches]["rainy"]).to eq({ leaf: "yes" })
    end
  end

  describe "#predict" do
    let(:tree) { model.build_tree(rows, features, label) }

    it "predicts no for sunny and weak" do
      expect(model.predict(tree, { outlook: "sunny", wind: "weak" })).to eq("no")
    end

    it "predicts yes for rainy and weak" do
      expect(model.predict(tree, { outlook: "rainy", wind: "weak" })).to eq("yes")
    end
  end

  describe "numeric splits" do
    let(:numeric_rows) { DecisionTreeData::NUMERIC_ROWS }

    it "finds 4.5 as the best threshold" do
      threshold, gain = model.best_numeric_split(numeric_rows, :studied, :result)

      expect(threshold).to eq(4.5)
      expect(gain).to eq(0.5)
    end

    it "predicts using the numeric threshold tree" do
      tree = model.build_numeric_tree(numeric_rows, [:studied], :result)

      expect(model.predict_numeric(tree, { studied: 3.0 })).to eq("fail")
      expect(model.predict_numeric(tree, { studied: 6.0 })).to eq("pass")
    end
  end
end
