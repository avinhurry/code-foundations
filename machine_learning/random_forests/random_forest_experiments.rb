require_relative "random_forest"
require_relative "random_forest_data"

model = RandomForest.new
rows = %i[a b c d e]

puts "=================="
puts "Bootstrap sampling"
puts "=================="
puts

3.times do |index|
  sample = model.bootstrap_sample(rows)
  puts "Sample #{index + 1}: #{sample.inspect}"
end

puts
puts "Each bootstrap sample has the same number of rows as the original, but some values repeat and some may be missing because sampling is done with replacement."

samples = 1000
average_fraction_present = samples.times.sum do
  sample = model.bootstrap_sample(rows)
  sample.uniq.length.to_f / rows.length
end / samples

puts
puts "Average fraction of original values present over #{samples} samples: #{average_fraction_present.round(3)}"
puts "With only 5 original values, the expected fraction is about 0.672. As the dataset gets larger, this approaches about 0.632, or 63%."

puts
puts "======================="
puts "One tree vs the forest"
puts "======================="
puts

features = %i[outlook wind humidity temperature day_type]
label = :play
runs = 20
single_tree_accuracies = []
forest_accuracies = []
decision_tree = DecisionTree.new

runs.times do
  shuffled = RandomForestData::NOISY_ROWS.shuffle
  train_rows = shuffled.first(54)
  test_rows = shuffled.last(18)

  tree = decision_tree.build_tree(train_rows, features, label)
  tree_correct = test_rows.count do |row|
    decision_tree.predict(tree, row) == row[label]
  end
  single_tree_accuracies << tree_correct.to_f / test_rows.length

  forest = RandomForest.new(n_trees: 100, max_features: 1).fit(train_rows, features, label)
  forest_correct = test_rows.count do |row|
    forest.predict(row) == row[label]
  end
  forest_accuracies << forest_correct.to_f / test_rows.length
end

single_tree_average = single_tree_accuracies.sum / runs
forest_average = forest_accuracies.sum / runs
single_tree_spread = single_tree_accuracies.max - single_tree_accuracies.min
forest_spread = forest_accuracies.max - forest_accuracies.min

puts "Single tree accuracies: #{single_tree_accuracies.inspect}"
puts "Forest accuracies:      #{forest_accuracies.inspect}"
puts
puts "Single tree average accuracy: #{single_tree_average.round(3)}"
puts "Forest average accuracy:      #{forest_average.round(3)}"
puts "Single tree spread:           #{single_tree_spread.round(3)}"
puts "Forest spread:                #{forest_spread.round(3)}"
puts
puts "The forest was more accurate on average across these runs. The spread shows how far each model ranged between its best and worst test accuracy, so compare the two values rather than assuming the forest will always have the smaller spread."

puts
puts "===================="
puts "Watch the crowd grow"
puts "===================="
puts

shuffled = RandomForestData::NOISY_ROWS.shuffle
train_rows = shuffled.first(54)
test_rows = shuffled.last(18)
forest_runs = 20

[1, 5, 25, 100].each do |tree_count|
  accuracies = Array.new(forest_runs) do
    forest = RandomForest.new(n_trees: tree_count, max_features: 1).fit(train_rows, features, label)
    correct = test_rows.count do |row|
      forest.predict(row) == row[label]
    end

    correct.to_f / test_rows.length
  end

  average_accuracy = accuracies.sum / forest_runs
  tree_label = tree_count == 1 ? "tree" : "trees"
  puts "#{tree_count} #{tree_label}: #{average_accuracy.round(3)} average accuracy"
end

puts
puts "Averaging several forests at each size makes it easier to see whether performance starts to settle as more trees are added."


puts
puts "========================"
puts "Turn the diversity dial"
puts "========================"
puts

[1, 2, 3, 4, 5].each do |max_features|
  accuracies = Array.new(forest_runs) do
    forest = RandomForest.new(n_trees: 100, max_features: max_features).fit(train_rows, features, label)
    correct = test_rows.count do |row|
      forest.predict(row) == row[label]
    end

    correct.to_f / test_rows.length
  end

  average_accuracy = accuracies.sum / forest_runs
  puts "max_features #{max_features}: #{average_accuracy.round(3)} average accuracy"
end

puts
puts "If max_features is small, each split is more likely to randomly look at different features, so the trees grow differently. If max_features is large, the same high-gain features are more likely to be available and chosen by different trees, which can make the trees more similar. Compare the average accuracies to see which value works best for this run."


puts
puts "=================="
puts "Out-of-bag score"
puts "=================="
puts

forest = RandomForest.new(n_trees: 100, max_features: 1).fit(train_rows, features, label)

test_correct = test_rows.count do |row|
  forest.predict(row) == row[label]
end

test_accuracy = test_correct.to_f / test_rows.length

puts "OOB accuracy:  #{forest.oob_score.round(3)}"
puts "Test accuracy: #{test_accuracy.round(3)}"
puts
puts "For each training row, the OOB score only uses trees that did not see that row during training. This gives us another estimate of how well the forest handles unseen data."