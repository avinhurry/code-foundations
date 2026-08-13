require_relative "../statistics"

class LogisticRegression
  attr_reader :weights, :bias, :loss_history

  # Sets up the model with a learning rate, number of training iterations, prediction threshold and L2 strength.
  def initialize(learning_rate: 0.1, iterations: 5_000, threshold: 0.5, lambda: 0.0)
    @learning_rate = learning_rate
    @iterations    = iterations
    @threshold     = threshold
    @lambda        = lambda
  end

  # rows: the training data
  # ys: the target labels for each row (1 = positive class, 0 = negative class)
  # The positive class is the outcome the model is trying to detect; the negative class is the opposite outcome.
  # Trains the model using gradient descent.
  # Gradient descent repeatedly adjusts the weights and bias to reduce log-loss.
  def fit(rows, ys)
    n_samples  = rows.length
    n_features = rows.first.length
    @weights   = Array.new(n_features, 0.0)
    @bias      = 0.0
    @loss_history = []

    @iterations.times do
      probabilities = rows.map { |row| predict_probability_row(row) }

      # Compare each predicted probability with the actual 0/1 label.
      errors = probabilities.each_index.map { |i| probabilities[i] - ys[i] }
      @loss_history << log_loss(probabilities, ys)

      n_features.times do |j|
        # Work out how much this feature's weight contributed to the errors.
        gradient = rows.each_index.sum { |i| errors[i] * rows[i][j] } / n_samples.to_f

        # L2 regularization adds a penalty for large weights. The bias is not penalized.
        gradient += @lambda * @weights[j]
        @weights[j] = @weights[j] - (@learning_rate * gradient)
      end

      @bias = @bias - (@learning_rate * errors.sum / n_samples.to_f)
    end

    self
  end

  # Squashes any raw score into a probability between 0 and 1.
  def sigmoid(score)
    1.0 / (1.0 + Math.exp(-score))
  end

  # Predicts the probability of the positive class for a single row of input data.
  def predict_probability_row(row)
    score = row.each_index.sum { |j| @weights[j] * row[j] } + @bias
    sigmoid(score)
  end

  # Predicts positive class probabilities for multiple rows.
  def predict_proba(rows)
    rows.map { |row| predict_probability_row(row) }
  end

  # Converts probabilities into class labels using the prediction threshold.
  def predict(rows)
    predict_proba(rows).map { |probability| probability >= @threshold ? 1 : 0 }
  end

  # Measures how wrong the predicted probabilities are compared with the actual 0/1 labels.
  def log_loss(probabilities, ys)
    epsilon = 1e-15

    probabilities.each_index.sum do |i|
      probability = [[probabilities[i], epsilon].max, 1.0 - epsilon].min
      actual = ys[i]

      -(actual * Math.log(probability) + (1 - actual) * Math.log(1 - probability))
    end / probabilities.length.to_f
  end
end

# ---- feature scaling -------------------------------------------------------

# Scales the input data to help gradient descent train more effectively.
def standardize(rows)
  Statistics.standardize(rows)
end