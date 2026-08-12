

module ClassificationMetrics
  module_function

  # Counts the four possible outcomes when comparing binary predictions with the actual labels.
  def confusion(predictions, actuals)
    {
      true_positives: predictions.zip(actuals).count { |prediction, actual| prediction == 1 && actual == 1 },
      false_positives: predictions.zip(actuals).count { |prediction, actual| prediction == 1 && actual == 0 },
      true_negatives: predictions.zip(actuals).count { |prediction, actual| prediction == 0 && actual == 0 },
      false_negatives: predictions.zip(actuals).count { |prediction, actual| prediction == 0 && actual == 1 }
    }
  end

  def accuracy(predictions, actuals)
    correct = predictions.zip(actuals).count { |prediction, actual| prediction == actual }
    correct / actuals.length.to_f
  end

  # Of everything predicted as positive, how much was actually positive?
  def precision(predictions, actuals)
    counts = confusion(predictions, actuals)
    predicted_positives = counts[:true_positives] + counts[:false_positives]
    return 0.0 if predicted_positives.zero?

    counts[:true_positives] / predicted_positives.to_f
  end

  # Of everything actually positive, how much did the model find?
  def recall(predictions, actuals)
    counts = confusion(predictions, actuals)
    actual_positives = counts[:true_positives] + counts[:false_negatives]
    return 0.0 if actual_positives.zero?

    counts[:true_positives] / actual_positives.to_f
  end

  # Combines precision and recall into one score, with a low value in either one pulling the F1 score down.
  def f1(predictions, actuals)
    precision_score = precision(predictions, actuals)
    recall_score = recall(predictions, actuals)
    return 0.0 if (precision_score + recall_score).zero?

    2.0 * precision_score * recall_score / (precision_score + recall_score)
  end

  # Measures how often a randomly chosen positive case receives a higher probability than a negative case.
  def auc(probabilities, actuals)
    positives = probabilities.zip(actuals).filter_map { |probability, actual| probability if actual == 1 }
    negatives = probabilities.zip(actuals).filter_map { |probability, actual| probability if actual == 0 }
    return 0.0 if positives.empty? || negatives.empty?

    comparisons = positives.product(negatives)
    score = comparisons.sum do |positive_probability, negative_probability|
      if positive_probability > negative_probability
        1.0
      elsif positive_probability == negative_probability
        0.5
      else
        0.0
      end
    end

    score / comparisons.length
  end
end