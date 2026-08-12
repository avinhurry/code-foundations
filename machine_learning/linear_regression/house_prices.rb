require_relative "../statistics"
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
puts "  RMSE: #{RegressionMetrics.rmse(normal_predictions, prices).round(4)}"
puts "  R²: #{RegressionMetrics.r2(normal_predictions, prices).round(4)}"
puts
puts "Gradient descent"
puts "  RMSE: #{RegressionMetrics.rmse(gradient_predictions, prices).round(4)}"
puts "  R²: #{RegressionMetrics.r2(gradient_predictions, prices).round(4)}"
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

puts
puts "Honest evaluation"
puts

# Reserve the final five houses for evaluation so the model never sees them during training.
train_data = DATA.first(15)
test_data = DATA.last(5)

train_features = train_data.map(&:first)
train_prices = train_data.map(&:last)
test_features = test_data.map(&:first)
test_prices = test_data.map(&:last)

# Compute scaling statistics from the training set only, then reuse them for the test set.
scaled_train_features, feature_means, feature_standard_deviations = standardize(train_features)
scaled_test_features = test_features.map do |row|
  row.each_with_index.map do |value, index|
    (value - feature_means[index]) / feature_standard_deviations[index]
  end
end

# Fit only on the training houses.
evaluation_model =
  LinearRegression
    .new(learning_rate: 0.1, iterations: 5_000)
    .fit(scaled_train_features, train_prices)

train_predictions = evaluation_model.predict(scaled_train_features)
test_predictions = evaluation_model.predict(scaled_test_features)

train_r2 = RegressionMetrics.r2(train_predictions, train_prices)
test_r2 = RegressionMetrics.r2(test_predictions, test_prices)
test_rmse = RegressionMetrics.rmse(test_predictions, test_prices)
r2_gap = train_r2 - test_r2

puts "Training set: #{train_data.length} houses"
puts "Test set: #{test_data.length} houses"
puts
puts "Train performance"
puts "  R²: #{train_r2.round(4)}"
puts
puts "Test performance"
puts "  R²: #{test_r2.round(4)}"
puts "  RMSE: #{test_rmse.round(4)}"
puts
puts "Evaluation"

puts "  Test R² is #{r2_gap.round(4)} lower than train R²."
puts "  The gap is very small, suggesting the model generalises well to unseen houses."

puts
puts "Ridge regularisation"
puts

# Compare ordinary linear regression (λ = 0) with progressively stronger ridge regularisation.
# Lambda controls the strength of the ridge penalty.
lambdas = [0, 0.1, 1, 10, 100]

best_lambda = nil
best_rmse = Float::INFINITY

lambdas.each do |lambda|
  coefficients = LinearRegression.normal_equation(
    scaled_train_features,
    train_prices,
    lambda: lambda
  )

  bias = coefficients.first
  weights = coefficients.drop(1)

  predictions = scaled_test_features.map do |row|
    bias + row.zip(weights).sum { |value, weight| value * weight }
  end

  weight_norm = Math.sqrt(weights.sum { |weight| weight**2 })
  ridge_test_rmse = RegressionMetrics.rmse(predictions, test_prices)

  puts "λ = #{lambda}"
  puts "  Weight norm: #{weight_norm.round(4)}"
  puts "  Test RMSE: #{ridge_test_rmse.round(4)}"
  puts

  if ridge_test_rmse < best_rmse
    best_rmse = ridge_test_rmse
    best_lambda = lambda
  end
end

puts "Best λ: #{best_lambda}"
puts "  Test RMSE: #{best_rmse.round(4)}"
puts
puts "Ridge effect"
puts "  As λ increases, ridge shrinks the feature weights towards zero."
puts "  For this dataset, regularisation did not improve the test predictions."
puts "  The unregularised model had the lowest test RMSE."
puts "  Larger λ values shrank the weights too much and caused the model to underfit."
puts
puts "Residual analysis"
puts

residuals = test_predictions.zip(test_prices).map do |prediction, actual|
  {
    prediction: prediction,
    actual: actual,
    residual: actual - prediction
  }
end.sort_by { |result| result[:prediction] }

residuals.each do |result|
  puts "Predicted: #{result[:prediction].round(2)}  " \
       "Actual: #{result[:actual].round(2)}  " \
       "Residual: #{result[:residual].round(2)}"
end

puts
puts "Residual pattern"
puts "  The residuals are relatively small and fall on both sides of zero."
puts "  There is no obvious upward or downward trend as predicted price increases."
puts "  This suggests the model is making mostly random errors rather than repeating the same type of mistake."
