require_relative "../statistics"

class GradientBoosting
  attr_reader :rounds, :best_round, :best_validation_mse

  def initialize(n_rounds: 3, learning_rate: 1.0)
    @n_rounds = n_rounds
    @learning_rate = learning_rate
  end

  def fit(xs, ys, validation_xs: nil, validation_ys: nil, patience: nil)
    validate_data!(xs, ys, "training")
    early_stopping = early_stopping?(validation_xs, validation_ys, patience)

    @base_prediction = Statistics.mean(ys)
    @stumps = []
    @rounds = []
    @best_round = nil
    @best_validation_mse = nil
    best_stumps = nil
    rounds_without_improvement = 0

    # Start by predicting the average target for every row.
    predictions = Array.new(ys.length, @base_prediction)
    record_round(predictions, ys)

    if early_stopping
      @best_round = 0
      @best_validation_mse = mean_squared_error(
        validation_ys,
        Array.new(validation_ys.length, @base_prediction)
      )
      best_stumps = []
    end

    @n_rounds.times do
      # Each new stump learns the errors that are still left to fix.
      residuals = ys.each_index.map { |index| ys[index] - predictions[index] }
      stump = best_stump(xs, residuals)
      break unless stump

      @stumps << stump

      xs.each_index do |index|
        # Nudge the current prediction towards the correction suggested by this stump.
        predictions[index] += @learning_rate * stump_value(stump, xs[index])
      end

      record_round(predictions, ys)

      next unless early_stopping

      validation_predictions = validation_xs.map { |x| predict(x) }
      validation_mse = mean_squared_error(validation_ys, validation_predictions)

      if @best_validation_mse.nil? || validation_mse < @best_validation_mse
        @best_validation_mse = validation_mse
        @best_round = @stumps.length
        best_stumps = @stumps.dup
        rounds_without_improvement = 0
      else
        rounds_without_improvement += 1
        break if rounds_without_improvement >= patience
      end
    end

    if early_stopping
      @stumps = best_stumps
      @rounds = @rounds.first(@best_round + 1)
    end

    self
  end

  def predict(x)
    @base_prediction + @stumps.sum do |stump|
      @learning_rate * stump_value(stump, x)
    end
  end

  private

  def early_stopping?(validation_xs, validation_ys, patience)
    supplied_values = [validation_xs, validation_ys, patience]
    return false if supplied_values.all?(&:nil?)

    unless validation_xs && validation_ys && patience
      raise ArgumentError, "validation_xs, validation_ys and patience must be provided together"
    end

    validate_data!(validation_xs, validation_ys, "validation")
    raise ArgumentError, "patience must be a positive integer" unless patience.is_a?(Integer) && patience.positive?

    true
  end

  def validate_data!(xs, ys, name)
    raise ArgumentError, "#{name} data must not be empty" if xs.empty? || ys.empty?
    raise ArgumentError, "#{name} xs and ys must have the same length" unless xs.length == ys.length
  end

  # Tries every possible split and returns the stump with the lowest squared error.
  def best_stump(xs, targets)
    thresholds = xs.uniq.sort.each_cons(2).map { |left, right| (left + right) / 2.0 }

    thresholds.map do |threshold|
      left_indices = xs.each_index.select { |index| xs[index] <= threshold }
      right_indices = xs.each_index.select { |index| xs[index] > threshold }

      left_mean = Statistics.mean(left_indices.map { |index| targets[index] })
      right_mean = Statistics.mean(right_indices.map { |index| targets[index] })

      squared_error =
        left_indices.sum { |index| (targets[index] - left_mean)**2 } +
        right_indices.sum { |index| (targets[index] - right_mean)**2 }

      {
        threshold: threshold,
        left: left_mean,
        right: right_mean,
        squared_error: squared_error
      }
    end.min_by { |stump| stump[:squared_error] }
  end

  def stump_value(stump, x)
    x <= stump[:threshold] ? stump[:left] : stump[:right]
  end

  def mean_squared_error(actual, predictions)
    actual.each_index.sum do |index|
      (actual[index] - predictions[index])**2
    end / actual.length.to_f
  end

  def record_round(predictions, ys)
    residuals = ys.each_index.map { |index| ys[index] - predictions[index] }
    mse = residuals.sum { |residual| residual**2 } / residuals.length.to_f

    @rounds << {
      predictions: predictions.dup,
      residuals: residuals,
      mse: mse
    }
  end
end
