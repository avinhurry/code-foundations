# frozen_string_literal: true

require_relative "linear_regression"

puts "Linear Regression Experiments"
puts "============================="

puts
puts "Experiment 1: Training a model using the normal equation"
puts "----------------------------"

# Training examples:
# - rows: input features
# - ys: expected outputs
rows = [[1, 1],[2, 1],[3, 2],[4, 2],[5, 3],[6, 3],[7, 4],[8, 4],[9, 5],[10, 5]].map { |r| r.map(&:to_f) }
ys   = [12, 12, 26, 26, 38, 39, 49, 55, 62, 67].map(&:to_f)

# Train the model by learning the bias and weights
coefficients = LinearRegression.normal_equation(rows, ys)

# Assign the learned bias and weights to variables
bias, weight1, weight2 = coefficients

# Use the learned bias and weights to predict the first training example
prediction = bias + (weight1 * rows[0][0]) + (weight2 * rows[0][1])

# Compare the prediction with the actual value
puts "Prediction: #{prediction}"
puts "Actual:     #{ys[0]}"

puts
puts "Experiment 2: Training a model with gradient descent"
puts "---------------------------------------------------"

# Use the same training examples as Experiment 1
# Train the model by gradually improving guesses for the bias and weights
model = LinearRegression.new(
  learning_rate: 0.01,
  iterations: 10_000
).fit(rows, ys)

# Use the trained model to predict the first training example
prediction = model.predict([rows[0]]).first

# Compare the prediction with the actual value
puts "Prediction: #{prediction}"
puts "Actual:     #{ys[0]}"

puts
puts "Experiment 3: Comparing the two training algorithms"
puts "---------------------------------------------------"
puts

# Assign the gradient descent bias and weights to variables
gd_bias, gd_weight1, gd_weight2 = model.bias, model.weights[0], model.weights[1]

puts "Normal equation:"
puts "  Bias:    #{coefficients[0]}"
puts "  Weight1: #{coefficients[1]}"
puts "  Weight2: #{coefficients[2]}"
puts
puts "Gradient descent:"
puts "  Bias:    #{gd_bias}"
puts "  Weight1: #{gd_weight1}"
puts "  Weight2: #{gd_weight2}"
puts
puts "Difference:"
puts "  Bias:    #{(gd_bias - coefficients[0]).abs}"
puts "  Weight1: #{(gd_weight1 - coefficients[1]).abs}"
puts "  Weight2: #{(gd_weight2 - coefficients[2]).abs}"

puts
puts "Experiment 4: Comparing predictions with scaled features"
puts "--------------------------------------------------------"
puts

# Standardize the features before training with gradient descent.
# Standardization is one way of performing feature scaling, which transforms
# each feature so its values are on a similar scale.
scaled_rows, = standardize(rows)

scaled_model = LinearRegression.new(
  learning_rate: 0.1,
  iterations: 5_000
).fit(scaled_rows, ys)

# Compare the learned parameters from the original and standardized features.
puts "Normal equation parameters (unscaled features):"
puts "  Bias:    #{bias}"
puts "  Weight1: #{weight1}"
puts "  Weight2: #{weight2}"
puts
puts "Gradient descent parameters (scaled features):"
puts "  Bias:    #{scaled_model.bias}"
puts "  Weight1: #{scaled_model.weights[0]}"
puts "  Weight2: #{scaled_model.weights[1]}"
puts

# Use the normal equation coefficients to predict every training example.
normal_equation_predictions = rows.map do |row|
  bias + (weight1 * row[0]) + (weight2 * row[1])
end

# Use the scaled gradient descent model to predict the same examples.
gradient_descent_predictions = scaled_model.predict(scaled_rows)

# Compare the predictions from the standardized gradient descent model
# with the predictions from the normal equation.
puts "Predictions:"
normal_equation_predictions.zip(gradient_descent_predictions).each_with_index do |(normal_prediction, gradient_prediction), index|
  puts "  Row #{index + 1}: normal=#{normal_prediction.round(4)} gradient=#{gradient_prediction.round(4)}"
end

# Compare the error of both models using RMSE.
puts
puts "RMSE"
puts "  Normal equation: #{Metrics.rmse(normal_equation_predictions, ys).round(4)}"
puts "  Gradient descent: #{Metrics.rmse(gradient_descent_predictions, ys).round(4)}"

# Compare how well each model fits the data using R².
puts
puts "R²"
puts "  Normal equation: #{Metrics.r2(normal_equation_predictions, ys).round(4)}"
puts "  Gradient descent: #{Metrics.r2(gradient_descent_predictions, ys).round(4)}"
puts
puts "The parameters differ because one model was trained on the original features and the other on standardized features."
puts "Even though the parameters differ, both models learn the same relationship, so they make the same predictions."

puts
puts "Experiment 5: How feature scaling affects gradient descent"
puts "----------------------------------------------------------"
puts

# The feature values are on different scales, so a large learning rate
# may cause gradient descent to become unstable.
unscaled_high_rate_model = LinearRegression.new(
  learning_rate: 0.1,
  iterations: 100
).fit(rows, ys)

puts "Unscaled features with learning rate 0.1:"
puts "  First loss:       #{unscaled_high_rate_model.loss_history.first}"
puts "  Loss at step 10:  #{unscaled_high_rate_model.loss_history[9]}"
puts "  Final loss:       #{unscaled_high_rate_model.loss_history.last}"
puts

unscaled_lower_rate_model = LinearRegression.new(
  learning_rate: 0.05,
  iterations: 100
).fit(rows, ys)

puts "Unscaled features with learning rate 0.05:"
puts "  First loss:       #{unscaled_lower_rate_model.loss_history.first}"
puts "  Loss at step 10:  #{unscaled_lower_rate_model.loss_history[9]}"
puts "  Final loss:       #{unscaled_lower_rate_model.loss_history.last}"
puts

unscaled_small_rate_model = LinearRegression.new(
  learning_rate: 0.01,
  iterations: 100
).fit(rows, ys)

puts "Unscaled features with learning rate 0.01:"
puts "  First loss:       #{unscaled_small_rate_model.loss_history.first}"
puts "  Loss at step 10:  #{unscaled_small_rate_model.loss_history[9]}"
puts "  Final loss:       #{unscaled_small_rate_model.loss_history.last}"
puts

scaled_high_rate_model = LinearRegression.new(
  learning_rate: 0.1,
  iterations: 100
).fit(scaled_rows, ys)

puts "Scaled features with learning rate 0.1:"
puts "  First loss:       #{scaled_high_rate_model.loss_history.first}"
puts "  Loss at step 10:  #{scaled_high_rate_model.loss_history[9]}"
puts "  Final loss:       #{scaled_high_rate_model.loss_history.last}"
puts

scaled_fewer_iterations_model = LinearRegression.new(
  learning_rate: 0.1,
  iterations: 25
).fit(scaled_rows, ys)

puts "Scaled features with learning rate 0.1 and 25 iterations:"
puts "  First loss:       #{scaled_fewer_iterations_model.loss_history.first}"
puts "  Loss at step 10:  #{scaled_fewer_iterations_model.loss_history[9]}"
puts "  Final loss:       #{scaled_fewer_iterations_model.loss_history.last}"
puts
puts "Summary:"
puts "  Unscaled features were stable with learning rate 0.01."
puts "  Scaled features were stable with learning rate 0.1."
puts "  Scaling allowed a 10x larger learning rate (0.1 instead of 0.01) and reached a lower loss after only 25 iterations than the unscaled model reached after 100 iterations."

puts
puts "Experiment 6: Testing whether bedrooms improve the model"
puts "--------------------------------------------------------"
puts

# Keep only the size feature from each training example.
size_only_rows = rows.map { |row| [row[0]] }

# Train a new model using size as the only feature.
size_only_coefficients = LinearRegression.normal_equation(size_only_rows, ys)
size_only_bias, size_only_weight = size_only_coefficients

# Use the size only model to predict every training example.
size_only_predictions = size_only_rows.map do |row|
  size_only_bias + (size_only_weight * row[0])
end

# Compare the size only model with the existing size and bedrooms model.
size_only_r2 = Metrics.r2(size_only_predictions, ys)
two_feature_r2 = Metrics.r2(normal_equation_predictions, ys)
r2_improvement = two_feature_r2 - size_only_r2

puts "Size only:"
puts "  R²: #{size_only_r2.round(4)}"
puts
puts "Size and bedrooms:"
puts "  R²: #{two_feature_r2.round(4)}"
puts
puts "Improvement from adding bedrooms:"
puts "  R²: #{r2_improvement.round(4)}"
puts
puts "Conclusion:"
puts "  House size explains most of the variation in price."
puts "  Adding bedrooms improves R² from 0.9828 to 0.9949."
puts "  Bedrooms therefore improve the model, but size is by far the more important feature."
puts "  Measuring the improvement helps determine whether an additional feature is worth including in the model."


puts
puts "Experiment 7: Evaluating the model on unseen data"
puts "-------------------------------------------------"
puts

# Split the examples into training and test sets.
training_rows = rows.first(8)
training_ys = ys.first(8)
test_rows = rows.last(2)
test_ys = ys.last(2)

# Train the model using only the training examples.
training_coefficients = LinearRegression.normal_equation(training_rows, training_ys)
training_bias, training_weight1, training_weight2 = training_coefficients

# Evaluate the model on the same examples it was trained on.
training_predictions = training_rows.map do |row|
  training_bias + (training_weight1 * row[0]) + (training_weight2 * row[1])
end

# Evaluate the model on examples it did not see during training.
test_predictions = test_rows.map do |row|
  training_bias + (training_weight1 * row[0]) + (training_weight2 * row[1])
end

training_rmse = Metrics.rmse(training_predictions, training_ys)
test_rmse = Metrics.rmse(test_predictions, test_ys)
rmse_gap = test_rmse - training_rmse

puts "Training data:"
puts "  RMSE: #{training_rmse.round(4)}"
puts
puts "Test data:"
puts "  RMSE: #{test_rmse.round(4)}"
puts
puts "Gap:"
puts "  RMSE: #{rmse_gap.round(4)}"
puts
puts "Conclusion:"
puts "  The model was trained using the first 8 training examples."
puts "  The training RMSE measures how accurately the model predicts those 8 training examples."
puts "  The test RMSE measures how accurately the model predicts the final 2 test examples that were not used during training."
puts "  Because the test RMSE is higher than the training RMSE, the model performs slightly worse on unseen examples than on the examples it was trained on."
puts "  The test RMSE is therefore a better estimate of how well the model is likely to perform on new data."