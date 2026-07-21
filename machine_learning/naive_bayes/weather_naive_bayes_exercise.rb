# frozen_string_literal: true

# =============================================================================
#  EXERCISE SKELETON — NaiveBayes class: "Will I go for a run?"
#
#  Read instructions.md for the full brief and target numbers.
#  Replace each `raise NotImplementedError` with a real implementation, then:
#
#      ruby weather_naive_bayes_exercise.rb
#
#  The runner at the bottom prints your results next to the target values.
#  Work the tiers in order. The methods are grouped by tier.
#
#  Smoothing is the `alpha:` constructor argument:
#    alpha: 0  -> raw counts, which exposes the zero-frequency bug
#    alpha: 1  -> add-one smoothing, which fixes the bug
# =============================================================================

DATA = [
  { outlook: "sunny", temp: "hot", humidity: "high", wind: "weak", run: "no" },
  { outlook: "sunny", temp: "hot", humidity: "high", wind: "strong", run: "no" },
  { outlook: "overcast", temp: "hot", humidity: "high", wind: "weak", run: "yes" },
  { outlook: "rainy", temp: "mild", humidity: "high", wind: "weak", run: "yes" },
  { outlook: "rainy", temp: "cool", humidity: "normal", wind: "weak", run: "yes" },
  { outlook: "rainy", temp: "cool", humidity: "normal", wind: "strong", run: "no" },
  { outlook: "overcast", temp: "cool", humidity: "normal", wind: "strong", run: "yes" },
  { outlook: "sunny", temp: "mild", humidity: "high", wind: "weak", run: "no" },
  { outlook: "sunny", temp: "cool", humidity: "normal", wind: "weak", run: "yes" },
  { outlook: "rainy", temp: "mild", humidity: "normal", wind: "weak", run: "yes" },
  { outlook: "sunny", temp: "mild", humidity: "normal", wind: "strong", run: "yes" },
  { outlook: "overcast", temp: "mild", humidity: "high", wind: "strong", run: "yes" },
  { outlook: "overcast", temp: "hot", humidity: "normal", wind: "weak", run: "yes" },
  { outlook: "rainy", temp: "mild", humidity: "high", wind: "strong", run: "no" }
].freeze

FEATURES = %i[outlook temp humidity wind].freeze
LABEL = :run
TEST_1 = { outlook: "sunny", temp: "cool", humidity: "high", wind: "strong" }.freeze
TEST_2 = { outlook: "overcast", temp: "mild", humidity: "normal", wind: "weak" }.freeze

class WeatherNaiveBayes
  attr_reader :features, :label, :alpha, :data, :value_counts

  def initialize(features:, label:, alpha: 1.0)
    @features = features
    @label = label
    @alpha = alpha
    @data = []
    @value_counts = {}
  end

  def fit(data)
    @data = data
    @value_counts = features.each_with_object({}) do |feature, hash|
      hash[feature] = data.map { |row| row[feature] }.uniq.size
    end
    self
  end

  def classes
    data.map { |row| row[label] }.uniq.sort
  end

  # ---- TIER 1: counting -----------------------------------------------------

  # P(run == klass): fraction of all rows in that class.
  # In ML, class/klass is the category being predicted ("yes" or "no"), not a Ruby class.
  def prior(klass)
    # Count the number of rows where the label matches the class, then divide by the total number of rows.
    # This is the baseline probability of the class before looking at any weather features.
    
    class_rows = data.count { |row| row[label] == klass }
    total_rows = data.count

    class_rows.to_f / total_rows
  end

  # P(feature == value | run == klass), optionally smoothed by alpha.
  def likelihood(feature, value, klass)
    # Find all rows belonging to the class, then count how many of those
    # rows have the requested feature value. Add alpha to avoid zero probabilities.

    class_rows = data.select { |row| row[label] == klass }
    matching_rows = class_rows.count { |row| row[feature] == value }

    (matching_rows + alpha).to_f / (class_rows.count + (alpha * value_counts[feature]))
  end

  # ---- TIER 2: prediction ---------------------------------------------------

  # prior(klass) * product of likelihood(feature, value, klass) over the sample.
  def score(sample, klass)
    # The probability of the class before looking at any features, multiplied by the likelihood of each feature value for that class.

    score = prior(klass)
    sample.each do |feature, value|
      score *= likelihood(feature, value, klass)
    end

    score
  end

  # Hash { class => probability }. Normalise class scores so they sum to 1.0.
  def predict_probability(sample)
    # Calculate the score for each class, then normalize the scores to get probabilities.

    scores = classes.each_with_object({}) do |klass, hash|
      hash[klass] = score(sample, klass)
    end

    total_score = scores.values.sum

    return scores.transform_values { Float::NAN } if total_score.zero?
    
    scores.transform_values { |score| score / total_score }
  end

  # ---- TIER 3: robustness ---------------------------------------------------

  # Like score, but in log-space.
  def log_score(sample, klass)
    # Use log-space to avoid underflow, where multiplying many tiny probabilities
    # can eventually cause them to be rounded towards zero.
    score = Math.log(prior(klass))

    sample.each do |feature, value|
      score += Math.log(likelihood(feature, value, klass))
    end

    score
  end

  # Hash { class => probability }, calculated from log scores.
  def predict_probability_log(sample)
    log_scores = classes.each_with_object({}) do |klass, hash|
      hash[klass] = log_score(sample, klass)
    end

    # Subtract the maximum log score before exponentiating to avoid huge or tiny
    # values. Only the differences between log scores matter, so subtracting the
    # same value from each score preserves the relative probabilities.
    
    max_log_score = log_scores.values.max
    
    normalised_scores = log_scores.transform_values do |score|
      Math.exp(score - max_log_score)
    end

    total_score = normalised_scores.values.sum

    normalised_scores.transform_values { |score| score / total_score }
  end

  # The winning class label.
  def predict(sample)
    predict_probability_log(sample).max_by { |_, probability| probability }.first
  end
end

# ---- TIER 3 stretch: evaluation ---------------------------------------------

# Training accuracy is high because the model is evaluated on the same data
# it was trained on. Leave-one-out accuracy is much lower because each row
# is predicted by a model that has not seen that row during training.

# Predict every row in data and return the fraction predicted correctly.
def training_accuracy(data, alpha: 1.0)
  model = WeatherNaiveBayes.new(features: FEATURES, label: LABEL, alpha: alpha).fit(data)
  correct_predictions = data.count do |row|
    sample = FEATURES.to_h { |feature| [feature, row[feature]] }

    model.predict(sample) == row[LABEL]
  end

  correct_predictions.to_f / data.count
end

# For each row: train on the other rows, predict the held-out one, return accuracy.
def leave_one_out_accuracy(data, alpha: 1.0)
  correct_predictions = data.each_with_index.count do |row, index|
    training_data = data.each_with_index.reject { |_, training_index| training_index == index }.map(&:first)
    model = WeatherNaiveBayes.new(features: FEATURES, label: LABEL, alpha: alpha).fit(training_data)

    sample = FEATURES.to_h { |feature| [feature, row[feature]] }

    model.predict(sample) == row[LABEL]
  end

  correct_predictions.to_f / data.count
end

# =============================================================================
#  RUNNER
# =============================================================================

def attempt(title)
  puts "\n== #{title} =="
  yield
rescue NotImplementedError => e
  puts "  (not implemented yet: #{e.message})"
end

if __FILE__ == $PROGRAM_NAME
  attempt("TIER 1 — counting") do
    model = WeatherNaiveBayes.new(features: FEATURES, label: LABEL, alpha: 1.0).fit(DATA)
    raw_model = WeatherNaiveBayes.new(features: FEATURES, label: LABEL, alpha: 0.0).fit(DATA)

    puts "  prior('yes')                       = #{model.prior('yes').round(4)}   TARGET 0.6429"
    puts "  prior('no')                        = #{model.prior('no').round(4)}   TARGET 0.3571"
    puts "  likelihood(sunny|no)    [alpha 0]  = #{raw_model.likelihood(:outlook, 'sunny', 'no').round(4)}   TARGET 0.6"
    puts "  likelihood(cool|yes)    [alpha 0]  = #{raw_model.likelihood(:temp, 'cool', 'yes').round(4)}   TARGET 0.3333"
    puts "  likelihood(overcast|no) [alpha 1]  = #{model.likelihood(:outlook, 'overcast', 'no').round(4)}   TARGET 0.125"
  end

  attempt("TIER 2 — predict, no smoothing") do
    raw_model = WeatherNaiveBayes.new(features: FEATURES, label: LABEL, alpha: 0.0).fit(DATA)
    test_1_probabilities = raw_model.predict_probability(TEST_1)
    test_2_probabilities = raw_model.predict_probability(TEST_2)

    puts "  TEST_1 P(yes)=#{test_1_probabilities['yes'].round(4)}   TARGET 0.2046"
    puts "  TEST_2 P(yes)=#{test_2_probabilities['yes'].round(4)}   TARGET 1.0  (zero-frequency bug)"
  end

  attempt("TIER 3 — predict, smoothing + log-space") do
    model = WeatherNaiveBayes.new(features: FEATURES, label: LABEL, alpha: 1.0).fit(DATA)
    test_1_probabilities = model.predict_probability_log(TEST_1)
    test_2_probabilities = model.predict_probability_log(TEST_2)

    puts "  TEST_1 P(yes)=#{test_1_probabilities['yes'].round(4)} -> #{model.predict(TEST_1)}   TARGET 0.2799 / no"
    puts "  TEST_2 P(yes)=#{test_2_probabilities['yes'].round(4)} -> #{model.predict(TEST_2)}   TARGET 0.9566 / yes"
    puts "  log_score(TEST_1, 'yes') = #{model.log_score(TEST_1, 'yes').round(4)}   TARGET -4.9499"
    puts "  log_score(TEST_1, 'no')  = #{model.log_score(TEST_1, 'no').round(4)}   TARGET -4.0051"
  end

  attempt("TIER 3 stretch — evaluation") do
    puts "  training accuracy = #{training_accuracy(DATA, alpha: 1.0).round(3)}   TARGET 0.929"
    puts "  leave-one-out acc = #{leave_one_out_accuracy(DATA, alpha: 1.0).round(3)}   TARGET 0.5"
  end
end