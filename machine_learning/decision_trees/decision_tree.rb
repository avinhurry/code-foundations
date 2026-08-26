class DecisionTree
  # Measures how mixed the labels are. Zero means every row has the same label.
  def gini(rows, label)
    count = rows.length.to_f
    return 0.0 if count.zero?

    label_counts = rows.each_with_object(Hash.new(0)) do |row, counts|
      counts[row[label]] += 1
    end

    1.0 - label_counts.values.sum { |label_count| (label_count / count)**2 }
  end

  # Measures how much splitting on a feature reduces impurity.
  def gain(rows, feature, label)
    count = rows.length.to_f
    groups = rows.group_by { |row| row[feature] }

    weighted_gini = groups.values.sum do |group|
      (group.length / count) * gini(group, label)
    end

    gini(rows, label) - weighted_gini
  end

  # Returns the most common label in a group of rows.
  def majority(rows, label)
    rows
      .group_by { |row| row[label] }
      .max_by { |_value, group| group.length }
      .first
  end

  # Recursively builds the tree by choosing the feature with the highest gain.
  def build_tree(rows, features, label, depth: 0, max_depth: nil)
    classes = rows.map { |row| row[label] }.uniq
    return { leaf: classes.first } if classes.length == 1 # pure -> leaf
    return { leaf: majority(rows, label) } if features.empty? # no questions left
    return { leaf: majority(rows, label) } if max_depth && depth >= max_depth # depth limit reached

    best_feature = features.max_by { |feature| gain(rows, feature, label) }
    return { leaf: majority(rows, label) } if gain(rows, best_feature, label) <= 0

    branches = rows.group_by { |row| row[best_feature] }.transform_values do |group|
      build_tree(
        group,
        features - [best_feature],
        label,
        depth: depth + 1,
        max_depth: max_depth
      )
    end

    { feature: best_feature, branches: branches }
  end

  # Walks the tree until it reaches a leaf and returns the prediction.
  def predict(tree, row)
    return tree[:leaf] if tree.key?(:leaf)

    child = tree[:branches][row[tree[:feature]]]
    child ? predict(child, row) : nil # nil = a value never seen in training
  end
  
  # Measures how much a numeric threshold split reduces impurity.
  def numeric_gain(rows, feature, threshold, label)
    left = rows.select { |row| row[feature] <= threshold }
    right = rows.select { |row| row[feature] > threshold }
    return 0.0 if left.empty? || right.empty?

    count = rows.length.to_f
    weighted_gini = (left.length / count) * gini(left, label) +
                    (right.length / count) * gini(right, label)

    gini(rows, label) - weighted_gini
  end

  # Tries the midpoints between sorted values and keeps the threshold with the highest gain.
  def best_numeric_split(rows, feature, label)
    values = rows.map { |row| row[feature] }.uniq.sort
    thresholds = values.each_cons(2).map { |left, right| (left + right) / 2.0 }

    thresholds
      .map { |threshold| [threshold, numeric_gain(rows, feature, threshold, label)] }
      .max_by { |_threshold, split_gain| split_gain }
  end

  # Builds a decision tree using numeric threshold questions.
  def build_numeric_tree(rows, features, label)
    classes = rows.map { |row| row[label] }.uniq
    return { leaf: classes.first } if classes.length == 1

    candidates = features.filter_map do |feature|
      threshold, split_gain = best_numeric_split(rows, feature, label)
      [feature, threshold, split_gain] if threshold
    end

    best_feature, best_threshold, best_gain = candidates.max_by { |_feature, _threshold, split_gain| split_gain }
    return { leaf: majority(rows, label) } unless best_gain&.positive?

    left = rows.select { |row| row[best_feature] <= best_threshold }
    right = rows.select { |row| row[best_feature] > best_threshold }

    {
      feature: best_feature,
      threshold: best_threshold,
      left: build_numeric_tree(left, features, label),
      right: build_numeric_tree(right, features, label)
    }
  end

  # Walks a numeric tree by following the <= or > branch at each threshold.
  def predict_numeric(tree, row)
    return tree[:leaf] if tree.key?(:leaf)

    branch = row[tree[:feature]] <= tree[:threshold] ? tree[:left] : tree[:right]
    predict_numeric(branch, row)
  end
end
