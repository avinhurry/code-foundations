module RegressionMetrics
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
