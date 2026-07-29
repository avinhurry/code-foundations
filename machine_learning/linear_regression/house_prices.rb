require_relative "statistics"
require_relative "linear_regression"

DATA = [
  [[6.6, 3, 10], 62.4], [[9.1, 2, 19], 58.1], [[8.0, 5, 15], 83.3], [[3.0, 1, 9], 29.5],
  [[3.7, 5, 39], 60.8], [[8.9, 4, 0], 88.1], [[1.0, 1, 3], 24.6], [[8.4, 1, 7], 54.8],
  [[8.2, 3, 38], 56.9], [[5.2, 1, 27], 31.2], [[3.7, 1, 35], 34.1], [[3.5, 3, 8], 57.3],
  [[3.3, 5, 28], 58.9], [[5.0, 3, 14], 56.7], [[5.5, 5, 19], 76.2], [[6.0, 5, 0], 82.2],
  [[10.0, 5, 24], 88.1], [[8.1, 4, 33], 66.8], [[6.6, 3, 26], 59.1], [[9.9, 3, 6], 80.1]
].freeze

FEATURE_NAMES = %w[Size Bedrooms Age].freeze


def print_summary(name, values)
  summary = Statistics.summary(values)

  puts name
  puts "  Min: #{summary[:min]}"
  puts "  Max: #{summary[:max]}"
  puts "  Mean: #{summary[:mean].round(2)}"
  puts "  Std: #{summary[:standard_deviation].round(2)}"
  puts
end

# Separate the input features from the target prices.
features = DATA.map(&:first)
prices = DATA.map(&:last)

# Summarise the dataset before fitting a model.
puts "Features"
puts

FEATURE_NAMES.each_with_index do |name, index|
  values = features.map { |row| row[index] }
  print_summary(name, values)
end

puts "Target"
puts

print_summary("Price", prices)

# Standardise all features so gradient descent can train effectively and the weights are comparable.
scaled_features, = standardize(features)

# Fit the model directly using the normal equation.
normal_coefficients =
  LinearRegression.normal_equation(scaled_features, prices)

normal_bias = normal_coefficients.first
normal_weights = normal_coefficients.drop(1)
normal_predictions = scaled_features.map do |row|
  normal_bias + row.zip(normal_weights).sum { |value, weight| value * weight }
end

# Fit the same model iteratively using gradient descent.
gradient_model =
  LinearRegression
    .new(learning_rate: 0.1, iterations: 5_000)
    .fit(scaled_features, prices)

gradient_predictions = gradient_model.predict(scaled_features)

# Confirm that both training methods produce effectively identical predictions.
prediction_difference = normal_predictions
  .zip(gradient_predictions)
  .map { |normal, gradient| (normal - gradient).abs }
  .max

# Evaluate both models and report how closely their predictions agree.
puts "Multiple-feature model: price ~ size + bedrooms + age"
puts
puts "Normal equation"
puts "  RMSE: #{Metrics.rmse(normal_predictions, prices).round(4)}"
puts "  R²: #{Metrics.r2(normal_predictions, prices).round(4)}"
puts
puts "Gradient descent"
puts "  RMSE: #{Metrics.rmse(gradient_predictions, prices).round(4)}"
puts "  R²: #{Metrics.r2(gradient_predictions, prices).round(4)}"
puts
puts "Maximum prediction difference: #{format("%.12f", prediction_difference)}"
puts
puts "Weight interpretation"
puts "  Bias: #{normal_bias.round(2)} - predicted price when every feature is average."

# Explain how changing one feature affects the prediction while the others stay the same.
FEATURE_NAMES.zip(normal_weights).each do |name, weight|
  direction = weight.negative? ? "decreases" : "increases"

  other_features = FEATURE_NAMES.reject { |feature_name| feature_name == name }.map(&:downcase).join(" and ")

  puts "  #{name}: increasing #{name.downcase} by one standard deviation #{direction} predicted price by #{weight.abs.round(2)}, assuming #{other_features} stay the same."
end
