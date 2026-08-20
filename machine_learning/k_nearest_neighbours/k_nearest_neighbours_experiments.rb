require_relative "k_nearest_neighbours"
require_relative "../statistics"

puts
puts "=================="
puts "KNN classification"
puts "=================="
puts

DATA = [
  [[0.0, 0.0], "A"],
  [[1.0, 0.0], "B"],
  [[0.0, 1.0], "B"],
  [[2.0, 2.0], "B"],
  [[3.0, 3.0], "A"]
].freeze

query = [0.0, 0.0]

puts "Query: #{query.inspect}"
puts

[1, 3, 5].each do |k|
  model = KNearestNeighbours.new(k: k)
  prediction = model.classify(query, DATA)

  puts "k = #{k}: #{prediction}"
end

puts
puts "With k = 1, only the closest neighbour votes, so A wins. With k = 3, the three closest neighbours contain more B labels, so B wins."

puts
puts "=============="
puts "KNN regression"
puts "=============="
puts

REGRESSION_DATA = [
  [[1.0], 10.0],
  [[2.0], 15.0],
  [[4.0], 22.0],
  [[5.0], 30.0],
  [[6.0], 35.0]
].freeze

regression_query = [4.5]

puts "Query size: #{regression_query.first}"
puts

[1, 3].each do |k|
  model = KNearestNeighbours.new(k: k)
  prediction = model.regress(regression_query, REGRESSION_DATA)

  puts "k = #{k}: #{prediction.round(2)}"
end

puts
puts "With k = 1, the nearest size has price 22. With k = 3, the three nearest prices average to 29."


puts
puts "==================="
puts "Why scaling matters"
puts "==================="
puts

SCALING_DATA = [
  [[52_000.0, 24.0], "basic"],
  [[48_000.0, 26.0], "basic"],
  [[45_000.0, 27.0], "basic"],
  [[51_000.0, 55.0], "premium"],
  [[49_000.0, 60.0], "premium"],
].freeze

scaling_query = [50_500.0, 25.0]
scaling_model = KNearestNeighbours.new(k: 3)
unscaled_prediction = scaling_model.classify(scaling_query, SCALING_DATA)

features = SCALING_DATA.map(&:first)
scaled_features, means, standard_deviations = Statistics.standardize(features)
scaled_query = scaling_query.each_index.map do |index|
  (scaling_query[index] - means[index]) / standard_deviations[index]
end
scaled_data = scaled_features.each_index.map do |index|
  [scaled_features[index], SCALING_DATA[index][1]]
end
scaled_prediction = scaling_model.classify(scaled_query, scaled_data)

puts "Query: income $#{scaling_query.first.to_i}, age #{scaling_query.last.to_i}"
puts
puts "Without scaling: #{unscaled_prediction}"
puts "With scaling:    #{scaled_prediction}"
puts
puts "Without scaling, income dominates the distance calculation and gives the wrong prediction. After standardizing the features, age gets a fair influence and the prediction changes to basic."


puts
puts "========"
puts "Tuning k"
puts "========"
puts

TUNING_TRAIN_DATA = [
  [[0.0], "A"],
  [[1.0], "A"],
  [[2.0], "A"],
  [[3.0], "B"],
  [[4.0], "A"],
  [[5.0], "B"],
  [[6.0], "A"],
  [[7.0], "B"],
  [[8.0], "B"]
].freeze

TUNING_TEST_DATA = [
  [[0.5], "A"],
  [[2.1], "A"],
  [[4.5], "B"],
  [[7.5], "B"]
].freeze

accuracies = [1, 3, 5, 7].to_h do |k|
  model = KNearestNeighbours.new(k: k)
  predictions = TUNING_TEST_DATA.map do |features, _label|
    model.classify(features, TUNING_TRAIN_DATA)
  end
  actual = TUNING_TEST_DATA.map { |_features, label| label }
  correct = predictions.each_index.count { |index| predictions[index] == actual[index] }
  accuracy = correct.to_f / actual.length

  puts "k = #{k}: accuracy #{accuracy.round(3)}"

  [k, accuracy]
end

best_k, best_accuracy = accuracies.max_by { |_k, accuracy| accuracy }
sqrt_n = Math.sqrt(TUNING_TRAIN_DATA.length)

puts
puts "Best k: #{best_k} with accuracy #{best_accuracy.round(3)}"
puts "√n: #{sqrt_n.round(3)}"
puts "The best k matches √n here: with 9 training examples, √9 = 3."

puts
puts "==================="
puts "Weighted KNN voting"
puts "==================="
puts

WEIGHTED_DATA = [
  [[0.1], "A"],
  [[1.0], "B"],
  [[1.1], "B"],
  [[5.0], "A"]
].freeze

weighted_query = [0.0]
weighted_model = KNearestNeighbours.new(k: 3)
plain_prediction = weighted_model.classify(weighted_query, WEIGHTED_DATA)
weighted_prediction = weighted_model.weighted_classify(weighted_query, WEIGHTED_DATA)

puts "Query: #{weighted_query.inspect}"
puts
puts "Plain KNN:    #{plain_prediction}"
puts "Weighted KNN: #{weighted_prediction}"
puts
puts "I trust the weighted prediction more here because the A neighbour is much closer to the query, so it should have more influence than the two farther B neighbours."
