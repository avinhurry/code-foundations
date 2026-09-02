require "rspec"
require_relative "random_forest"
require_relative "random_forest_data"

RSpec.describe RandomForest do
  let(:n_trees) { 100 }
  let(:max_features) { 2 }
  let(:model) { described_class.new(n_trees: n_trees, max_features: max_features) }
  let(:rows) { RandomForestData::NOISY_ROWS }
  let(:features) { %i[outlook wind humidity temperature day_type] }
  let(:label) { :play }

  describe "#bootstrap_sample" do
    it "returns the same number of rows as the original dataset" do
      sample = model.bootstrap_sample(rows)

      expect(sample.length).to eq(rows.length)
    end

    it "only contains rows from the original dataset" do
      sample = model.bootstrap_sample(rows)

      expect(sample).to all(satisfy { |row| rows.include?(row) })
    end

    it "can include the same row more than once" do
      allow(model).to receive(:bootstrap_indices).with(rows.length).and_return(Array.new(rows.length, 0))

      expect(model.bootstrap_sample(rows)).to eq(Array.new(rows.length, rows.first))
    end
  end

  describe "#fit" do
    it "returns itself after fitting" do
      expect(model.fit(rows, features, label)).to equal(model)
    end
  end

  describe "#predict" do
    it "returns the most common vote across trees" do
      model.instance_variable_set(:@trees, [
        { tree: { leaf: "yes" }, out_of_bag_indices: [] },
        { tree: { leaf: "no" }, out_of_bag_indices: [] },
        { tree: { leaf: "yes" }, out_of_bag_indices: [] }
      ])

      expect(model.predict(rows.first)).to eq("yes")
    end
  end

  describe "#oob_score" do
    it "tracks OOB rows by index when identical rows are present" do
      duplicate_rows = [
        { outlook: "sunny", play: "no" },
        { outlook: "sunny", play: "no" }
      ]
      duplicate_model = described_class.new(n_trees: 1, max_features: 1)
      allow(duplicate_model).to receive(:bootstrap_indices).with(duplicate_rows.length).and_return([0, 0])

      duplicate_model.fit(duplicate_rows, [:outlook], :play)

      tree_data = duplicate_model.instance_variable_get(:@trees).first
      expect(tree_data[:out_of_bag_indices]).to eq([1])
      expect(duplicate_model.oob_score).to eq(1.0)
    end

    it "returns an accuracy between 0 and 1" do
      model.fit(rows, features, label)

      expect(model.oob_score).to be_between(0.0, 1.0)
    end
  end
end
