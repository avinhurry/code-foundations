require_relative "gradient_boosting"

xs = [1, 2, 3, 4, 5, 6]
ys = [3, 4, 10, 11, 20, 21]

model = GradientBoosting.new(
  n_rounds: 3,
  learning_rate: 1.0
)

model.fit(xs, ys)

puts "================"
puts "Trace the errors"
puts "================"
puts

model.rounds.each_with_index do |round, index|
  puts "Round #{index}"
  puts "Predictions: #{round[:predictions].map { |value| value.round(2) }}"
  puts "Residuals:   #{round[:residuals].map { |value| value.round(2) }}"
  puts "MSE:         #{round[:mse].round(2)}"
  puts
end

puts "The MSE falls each round because every new stump is trained to correct the residuals that are still left."
puts

puts "==============="
puts "Learning rate"
puts "==============="
puts

[
  { learning_rate: 1.0, n_rounds: 3 },
  { learning_rate: 0.1, n_rounds: 3 },
  { learning_rate: 0.1, n_rounds: 30 }
].each do |settings|
  model = GradientBoosting.new(
    n_rounds: settings[:n_rounds],
    learning_rate: settings[:learning_rate]
  )

  model.fit(xs, ys)
  final_round = model.rounds.last

  puts "Learning rate: #{settings[:learning_rate]}"
  puts "Rounds:        #{settings[:n_rounds]}"
  puts "Final MSE:     #{final_round[:mse].round(3)}"
  puts
end

puts "With the same number of rounds, the smaller learning rate improves more slowly because each stump makes a smaller correction. Giving it more rounds lets those smaller corrections build up."
puts
puts "================"
puts "Watch it overfit"
puts "================"
puts

# Synthetic regression data with a simple trend and repeating noise so we can observe overfitting.
noisy_xs = (1..30).to_a
noisy_ys = noisy_xs.map do |x|
  base = (x * 1.5) + 5
  noise = [0, 0, 0, 3, -3][x % 5]
  base + noise
end

train_indices = noisy_xs.each_index.reject { |index| index % 3 == 0 }
test_indices = noisy_xs.each_index.select { |index| index % 3 == 0 }

train_xs = train_indices.map { |index| noisy_xs[index] }
train_ys = train_indices.map { |index| noisy_ys[index] }
test_xs = test_indices.map { |index| noisy_xs[index] }
test_ys = test_indices.map { |index| noisy_ys[index] }

[1, 5, 10, 25, 50, 100, 200].each do |n_rounds|
  model = GradientBoosting.new(
    n_rounds: n_rounds,
    learning_rate: 0.1
  )

  model.fit(train_xs, train_ys)

  train_predictions = train_xs.map { |x| model.predict(x) }
  test_predictions = test_xs.map { |x| model.predict(x) }

  train_mse = train_ys.each_index.sum do |index|
    (train_ys[index] - train_predictions[index])**2
  end / train_ys.length.to_f

  test_mse = test_ys.each_index.sum do |index|
    (test_ys[index] - test_predictions[index])**2
  end / test_ys.length.to_f

  puts "Rounds:   #{n_rounds}"
  puts "Train MSE: #{train_mse.round(3)}"
  puts "Test MSE:  #{test_mse.round(3)}"
  puts
end

puts "As more rounds are added, the model keeps fitting the training data more closely, so training error falls. If error on unseen test data starts rising at the same time, the model is starting to overfit the training data instead of generalising well."
puts

puts "==================="
puts "Boosting vs forest"
puts "==================="
puts

puts "Random forest:"
puts "- builds trees independently"
puts "- uses bootstrap samples and random feature subsets"
puts "- combines predictions by voting"
puts "- is relatively forgiving to tune"
puts
puts "Gradient boosting:"
puts "- builds trees one after another"
puts "- each stump learns the residuals left by the current model"
puts "- combines predictions by adding small corrections"
puts "- learning rate and number of rounds matter much more"
puts
puts "The current random forest is a classifier while this gradient booster is a regressor, so their scores are not directly comparable."
puts
puts "=============="
puts "Early stopping"
puts "=============="
puts

early_train_indices = noisy_xs.each_index.select { |index| index % 3 == 1 }
validation_indices = noisy_xs.each_index.select { |index| index % 3 == 2 }

early_train_xs = early_train_indices.map { |index| noisy_xs[index] }
early_train_ys = early_train_indices.map { |index| noisy_ys[index] }
validation_xs = validation_indices.map { |index| noisy_xs[index] }
validation_ys = validation_indices.map { |index| noisy_ys[index] }

early_stopping_model = GradientBoosting.new(
  n_rounds: 500,
  learning_rate: 0.1
)

early_stopping_model.fit(
  early_train_xs,
  early_train_ys,
  validation_xs: validation_xs,
  validation_ys: validation_ys,
  patience: 20
)

puts "Best round:          #{early_stopping_model.best_round}"
puts "Best validation MSE: #{early_stopping_model.best_validation_mse.round(3)}"
puts
puts "Early stopping watches unseen validation data and stops when its error has not improved for the patience period. The model keeps the stumps from the best round."
