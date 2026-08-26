require_relative "decision_tree"
require_relative "decision_tree_data"

model = DecisionTree.new
rows = DecisionTreeData::CATEGORICAL_ROWS
label = :play

puts "======================"
puts "Gini impurity and gain"
puts "======================"
puts
puts "Root Gini:    #{model.gini(rows, label)}"
puts "Outlook gain: #{model.gain(rows, :outlook, label)}"
puts "Wind gain:    #{model.gain(rows, :wind, label)}"
puts
puts "The tree picks outlook first because it has the larger gain, so it reduces impurity more than wind."

puts
puts "========================="
puts "Build and read the tree"
puts "========================="
puts

features = %i[outlook wind]
tree = model.build_tree(rows, features, label)

p tree
puts

sunny_query = { outlook: "sunny", wind: "weak" }
rainy_query = { outlook: "rainy", wind: "weak" }

puts "Sunny + weak: #{model.predict(tree, sunny_query)}"
puts "Rainy + weak: #{model.predict(tree, rainy_query)}"
puts
puts "Sunny goes straight to the no leaf. Rainy follows the wind branch, where weak leads to yes."

puts
puts "===================="
puts "Limit the tree depth"
puts "===================="
puts

shallow_rows = rows + [
  { outlook: "rainy", wind: "weak", play: "yes" }
]
shallow_tree = model.build_tree(shallow_rows, features, label, max_depth: 1)

p shallow_tree
puts

rainy_weak_query = { outlook: "rainy", wind: "weak" }
rainy_strong_query = { outlook: "rainy", wind: "strong" }

puts "Rainy + weak:   #{model.predict(shallow_tree, rainy_weak_query)}"
puts "Rainy + strong: #{model.predict(shallow_tree, rainy_strong_query)}"
puts
puts "With max_depth = 1, the tree stops after asking about outlook. The rainy branch is still mixed, with 3 yes and 2 no labels, so it falls back to the majority label yes instead of asking about wind."
puts "This is worse because rainy + strong should predict no, but the shallow tree can no longer use wind to distinguish it from rainy + weak."

puts
puts "=================="
puts "Overfit on purpose"
puts "=================="
puts

overfit_rows = rows.each_with_index.map do |row, index|
  row.merge(day_id: index + 1)
end
overfit_features = %i[outlook wind day_id]
overfit_tree = model.build_tree(overfit_rows, overfit_features, label)

p overfit_tree
puts

correct = overfit_rows.count do |row|
  model.predict(overfit_tree, row) == row[label]
end
training_accuracy = correct.to_f / overfit_rows.length

puts "Training accuracy: #{training_accuracy.round(3)}"
puts
puts "The tree chooses the unique day_id because it can split every training row into its own pure leaf, giving perfect training accuracy."
puts "This is overfitting because day_id carries no useful pattern for predicting new days. The tree has overfitted to the training rows instead of learning a general rule."

puts
puts "======================"
puts "Numeric threshold splits"
puts "======================"
puts

numeric_rows = DecisionTreeData::NUMERIC_ROWS
numeric_tree = model.build_numeric_tree(numeric_rows, [:studied], :result)

p numeric_tree
puts

threshold, threshold_gain = model.best_numeric_split(numeric_rows, :studied, :result)
puts "Best threshold: #{threshold}"
puts "Gain:           #{threshold_gain.round(3)}"
puts "Studied 3 hours: #{model.predict_numeric(numeric_tree, { studied: 3.0 })}"
puts "Studied 6 hours: #{model.predict_numeric(numeric_tree, { studied: 6.0 })}"
puts
puts "The tree tries the midpoints between studied values and chooses 4.5 because it has the largest gain, meaning it best separates fail from pass in this toy dataset."
