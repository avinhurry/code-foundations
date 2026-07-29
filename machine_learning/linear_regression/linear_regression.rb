require "matrix"

class LinearRegression
  attr_reader :weights, :bias, :loss_history

  # Sets up the model with a learning rate and number of training iterations.
  def initialize(learning_rate: 0.1, iterations: 5_000, lambda: 0.0)
    @learning_rate = learning_rate
    @iterations    = iterations
    @lambda        = lambda
  end

  # rows: the training data
  # ys: the target values (correct answers) for each row
  # Trains the model using gradient descent.
  # Gradient descent repeatedly adjusts the weights and bias to reduce the prediction error.
  def fit(rows, ys)
    n_samples  = rows.length
    n_features = rows.first.length
    @weights   = Array.new(n_features, 0.0)
    @bias      = 0.0
    @loss_history = []

    @iterations.times do
      errors = rows.each_index.map { |i| predict_row(rows[i]) - ys[i] }
      prediction_loss = errors.sum { |error| error**2 } / n_samples.to_f
      ridge_loss = @lambda * @weights.sum { |weight| weight**2 }
      @loss_history << prediction_loss + ridge_loss

      n_features.times do |j|
        error_gradient = (2.0 / n_samples) * rows.each_index.sum { |i| errors[i] * rows[i][j] }
        ridge_gradient = 2.0 * @lambda * @weights[j]
        @weights[j] -= @learning_rate * (error_gradient + ridge_gradient)
      end
      @bias -= @learning_rate * (2.0 / n_samples) * errors.sum
    end
    self
  end

  # Predicts the target value for a single row of input data.
  def predict_row(row)
    row.each_index.sum { |j| @weights[j] * row[j] } + @bias
  end

  # Predicts the target values for multiple rows.
  def predict(rows)
    rows.map { |row| predict_row(row) }
  end

  # Calculates the weights and bias directly using linear algebra instead of gradient descent.
  def self.normal_equation(rows, ys, lambda: 0.0)
    x = Matrix[*rows.map { |row| [1.0] + row }]   # prepend the bias column of 1s
    y = Matrix.column_vector(ys)

    # Penalise the feature weights, but not the bias.
    ridge_penalty = Matrix.identity(x.column_count)
    ridge_penalty[0, 0] = 0.0

    beta = (
      x.transpose * x + rows.length * lambda * ridge_penalty
    ).inverse * x.transpose * y
    beta.column(0).to_a
  end
end

# ---- feature scaling -------------------------------------------------------

# Scales the input data to help gradient descent train more effectively.
def standardize(rows)
  n_features = rows.first.length
  means = Array.new(n_features) { |j| rows.sum { |r| r[j] } / rows.length.to_f }
  stds  = Array.new(n_features) do |j|
    var = rows.sum { |r| (r[j] - means[j])**2 } / rows.length.to_f
    Math.sqrt(var)
  end
  scaled = rows.map { |r| r.each_index.map { |j| (r[j] - means[j]) / stds[j] } }
  [scaled, means, stds]
end

# ---- metrics ---------------------------------------------------------------
module Metrics
  module_function

  # Calculates the Mean Squared Error.
  def mse(preds, ys)
    preds.each_index.sum { |i| (preds[i] - ys[i])**2 } / preds.length.to_f
  end

  # Calculates the Root Mean Squared Error.
  def rmse(preds, ys) = Math.sqrt(mse(preds, ys))

  # Calculates the Mean Absolute Error.
  def mae(preds, ys)
    preds.each_index.sum { |i| (preds[i] - ys[i]).abs } / preds.length.to_f
  end

  # Calculates the R² score, which measures how well the model fits the data.
  def r2(preds, ys)
    mean   = ys.sum / ys.length.to_f
    ss_res = preds.each_index.sum { |i| (preds[i] - ys[i])**2 }
    ss_tot = ys.sum { |y| (y - mean)**2 }
    1.0 - ss_res / ss_tot
  end

  # Calculates the adjusted R² score, which accounts for the number of features.
  def adjusted_r2(preds, ys, n_features)
    n_examples = ys.length

    if n_examples <= n_features + 1
      raise ArgumentError, "Adjusted R² requires more examples than features plus one"
    end

    r2_score = r2(preds, ys)

    1 - ((1 - r2_score) * (n_examples - 1).to_f / (n_examples - n_features - 1))
  end
end

if __FILE__ == $PROGRAM_NAME
  # ---- run it ----------------------------------------------------------------
  ROWS = [[1,1],[2,1],[3,2],[4,2],[5,3],[6,3],[7,4],[8,4],[9,5],[10,5]].map { |r| r.map(&:to_f) }
  YS   = [12, 12, 26, 26, 38, 39, 49, 55, 62, 67].map(&:to_f)

  # Exact solution:
  puts "normal equation [b, w_size, w_beds] = #{LinearRegression.normal_equation(ROWS, YS).map { |c| c.round(3) }}"
  # => [0.5, 2.4, 8.3]

  # Gradient descent on SCALED features, then score:
  scaled, = standardize(ROWS)
  model = LinearRegression.new(learning_rate: 0.1, iterations: 5_000).fit(scaled, YS)
  preds = model.predict(scaled)
  puts "RMSE=#{Metrics.rmse(preds, YS).round(4)}  MAE=#{Metrics.mae(preds, YS).round(4)}  R2=#{Metrics.r2(preds, YS).round(4)}"
  # => RMSE=1.3342  MAE=1.24  R2=0.9949
end