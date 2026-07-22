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