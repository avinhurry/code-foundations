# frozen_string_literal: true

require_relative "../statistics"
require_relative "../classification_metrics"
require_relative "logistic_regression"

# [tenure, monthly_charge, support_tickets], churned
DATA = [
  [[39, 54, 1], 1],
  [[5, 67, 2], 1],
  [[9, 79, 3], 0],
  [[12, 97, 5], 1],
  [[9, 43, 2], 0],
  [[38, 72, 5], 0],
  [[41, 76, 5], 0],
  [[28, 43, 1], 0],
  [[2, 20, 3], 0],
  [[5, 98, 6], 1],
  [[16, 44, 6], 0],
  [[21, 45, 5], 0],
  [[30, 91, 0], 0],
  [[23, 67, 5], 0],
  [[13, 58, 1], 0],
  [[8, 82, 6], 1],
  [[33, 22, 7], 0],
  [[35, 77, 3], 0],
  [[2, 50, 7], 1],
  [[6, 27, 6], 1],
  [[22, 73, 2], 0],
  [[19, 95, 7], 1],
  [[42, 37, 3], 0],
  [[25, 70, 0], 0]
].freeze

FEATURE_NAMES = ["Tenure", "Monthly charge", "Support tickets"].freeze

# Input features used to predict whether each customer churned.
ROWS = DATA.map(&:first).freeze

# Target labels: 1 means the customer churned, 0 means they stayed.
YS = DATA.map(&:last).freeze

def print_section(title)
  line = "=" * title.length

  puts
  puts line
  puts title
  puts line
  puts
end

# Returns the feature rows whose target label matches the supplied class.
def rows_for_class(label)
  DATA.filter_map { |row, churned| row if churned == label }
end

# Calculates the mean of each feature column for the supplied customer rows.
def feature_means(rows)
  FEATURE_NAMES.each_index.map do |feature_index|
    Statistics.mean(rows.map { |row| row[feature_index] })
  end
end

churners = rows_for_class(1)
stayers = rows_for_class(0)

print_section("Explore the data")
puts "Customer churn dataset"
puts
puts "Customers: #{DATA.length}"
puts "Churners: #{churners.length}"
puts "Stayers: #{stayers.length}"
puts "Churn rate: #{(Statistics.mean(YS) * 100).round(1)}%"
puts
puts "Feature means"
puts

churner_means = feature_means(churners)
stayer_means = feature_means(stayers)

FEATURE_NAMES.each_index do |feature_index|
  puts FEATURE_NAMES[feature_index]
  puts "  Churners: #{churner_means[feature_index].round(2)}"
  puts "  Stayers: #{stayer_means[feature_index].round(2)}"
  puts
end

puts "Initial observations"
puts
puts "- Churners had lower average tenure than stayers (12.0 vs 24.19), so lower tenure appears associated with churn."
puts "- Churners had a higher average monthly charge than stayers (71.25 vs 57.31), so higher monthly charges appear associated with churn."
puts "- Churners had more support tickets on average than stayers (5.0 vs 3.19), so more support tickets appear associated with churn."
puts
puts "These comparisons show patterns in this dataset only. They do not prove that any feature causes churn."
puts
puts "Exploration complete."

# Dumb baseline: predict that all customers will do what the majority do
always_stay_predictions = Array.new(YS.length, 0)
correct_predictions = always_stay_predictions.zip(YS).count do |prediction, actual|
  prediction == actual
end
baseline_accuracy = ClassificationMetrics.accuracy(always_stay_predictions, YS)

print_section("Baseline model")
puts 'Strategy: always predict "stay" (0)'
puts
puts "Correct predictions: #{correct_predictions}/#{YS.length}"
puts "Accuracy: #{(baseline_accuracy * 100).round(1)}%"
puts

puts "This is the baseline a real model should beat."

# Standardize the features before training; the mean and standard deviation are not needed here.
standardized_rows, _means, _standard_deviations = standardize(ROWS)
model = LogisticRegression.new
model.fit(standardized_rows, YS)

probabilities = model.predict_proba(standardized_rows)
predictions = model.predict(standardized_rows)
correct_predictions = predictions.zip(YS).count do |prediction, actual|
  prediction == actual
end
accuracy = ClassificationMetrics.accuracy(predictions, YS)
loss = model.log_loss(probabilities, YS)

print_section("Logistic regression model")
puts "Learned weights"
puts

# Show whether each feature pushes the prediction toward or away from churn.
FEATURE_NAMES.each_index do |feature_index|
  weight = model.weights[feature_index]
  direction = weight.positive? ? "positive" : "negative"

  puts "#{FEATURE_NAMES[feature_index]}: #{weight.round(3)} (#{direction})"
end

puts
puts "Correct predictions: #{correct_predictions}/#{YS.length}"
puts "Accuracy: #{(accuracy * 100).round(1)}%"
# Log loss measures the quality of the predicted probabilities; lower is better.
puts "Log loss: #{loss.round(3)}"

# Evaluate how well the model identifies churners beyond overall accuracy.
confusion = ClassificationMetrics.confusion(predictions, YS)
precision = ClassificationMetrics.precision(predictions, YS)
recall = ClassificationMetrics.recall(predictions, YS)
f1 = ClassificationMetrics.f1(predictions, YS)
auc = ClassificationMetrics.auc(probabilities, YS)

print_section("Classification metrics")
puts "True positives: #{confusion[:true_positives]}"
puts "False positives: #{confusion[:false_positives]}"
puts "True negatives: #{confusion[:true_negatives]}"
puts "False negatives: #{confusion[:false_negatives]}"
puts
puts "Precision: #{precision.round(3)}"
puts "Recall: #{recall.round(3)}"
puts "F1 score: #{f1.round(3)}"
puts "AUC: #{auc.round(3)}"

# The model's probabilities stay the same; changing the threshold only changes
# which customers are classified as churners.
print_section("Threshold tuning")

(2..8).each do |step|
  threshold = step / 10.0

  threshold_predictions = probabilities.map do |probability|
    probability >= threshold ? 1 : 0
  end

  precision = ClassificationMetrics.precision(threshold_predictions, YS)
  recall = ClassificationMetrics.recall(threshold_predictions, YS)
  churners_caught = threshold_predictions.zip(YS).count do |prediction, actual|
    prediction == 1 && actual == 1
  end

  puts "Threshold: #{threshold}"
  puts "  Precision: #{precision.round(3)}"
  puts "  Recall: #{recall.round(3)}"
  puts "  Churners caught: #{churners_caught}/#{churners.length}"
  puts
end

print_section("L2 regularization")

[0, 0.01, 0.1, 1].each do |lambda|
  regularized_model = LogisticRegression.new(lambda: lambda)
  regularized_model.fit(standardized_rows, YS)

  regularized_probabilities = regularized_model.predict_proba(standardized_rows)
  weight_norm = Math.sqrt(regularized_model.weights.sum { |weight| weight**2 })
  auc = ClassificationMetrics.auc(regularized_probabilities, YS)

  puts "Lambda: #{lambda}"
  puts "  Weight norm: #{weight_norm.round(3)}"
  puts "  AUC: #{auc.round(3)}"
  puts
end

puts "Regularization shrank the weights as lambda increased. AUC stayed the same up to 0.1, then dropped slightly at 1."
puts "This shows that regularization can keep the weights from becoming too large without reducing AUC, but too much can make the model worse at separating churners from stayers."
