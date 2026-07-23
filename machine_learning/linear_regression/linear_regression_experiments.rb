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
