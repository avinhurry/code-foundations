require_relative "../decision_trees/decision_tree"

class RandomForest
  def initialize(n_trees: 100, max_features: 1)
    @n_trees = n_trees
    @max_features = max_features
    @decision_tree = DecisionTree.new
  end

  # Creates a new dataset of the same size by sampling rows with replacement.
  def bootstrap_sample(rows)
    bootstrap_indices(rows.length).map { |index| rows[index] }
  end

  # Builds many random trees, each from its own bootstrap sample.
  def fit(rows, features, label)
    @rows = rows
    @label = label
    @trees = Array.new(@n_trees) do
      sample_indices = bootstrap_indices(rows.length)
      sample = sample_indices.map { |index| rows[index] }
      out_of_bag_indices = (0...rows.length).to_a - sample_indices

      {
        tree: build_random_tree(sample, features, label),
        out_of_bag_indices: out_of_bag_indices
      }
    end

    self
  end

  # Lets every tree vote and returns the most common prediction.
  def predict(row)
    votes = @trees.map { |tree_data| @decision_tree.predict(tree_data[:tree], row) }.compact
    return nil if votes.empty?

    votes.group_by(&:itself).max_by { |_label, group| group.length }.first
  end

  # Scores each training row using only trees that did not train on that row.
  def oob_score
    correct = 0
    scored = 0

    @rows.each_with_index do |row, index|
      votes = @trees.filter_map do |tree_data|
        next unless tree_data[:out_of_bag_indices].include?(index)

        @decision_tree.predict(tree_data[:tree], row)
      end

      next if votes.empty?

      prediction = votes.group_by(&:itself).max_by { |_label, group| group.length }.first
      correct += 1 if prediction == row[@label]
      scored += 1
    end

    correct.to_f / scored
  end

  private

  # Uses row positions so duplicate rows still have their own OOB status.
  def bootstrap_indices(row_count)
    Array.new(row_count) { rand(row_count) }
  end

  # Builds a tree where each split only considers some randomly chosen features instead of all of them.
  def build_random_tree(rows, features, label)
    classes = rows.map { |row| row[label] }.uniq
    return { leaf: classes.first } if classes.length == 1
    return { leaf: @decision_tree.majority(rows, label) } if features.empty?

    candidates = features.sample([@max_features, features.length].min)
    best_feature = candidates.max_by { |feature| @decision_tree.gain(rows, feature, label) }

    if @decision_tree.gain(rows, best_feature, label) <= 0
      return { leaf: @decision_tree.majority(rows, label) }
    end

    branches = rows.group_by { |row| row[best_feature] }.transform_values do |group|
      build_random_tree(group, features - [best_feature], label)
    end

    { feature: best_feature, branches: branches }
  end
end
