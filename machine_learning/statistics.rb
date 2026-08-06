module Statistics
  module_function

  def mean(values)
    values.sum.to_f / values.length
  end

  def standard_deviation(values)
    average = mean(values)

    variance = values.sum do |value|
      (value - average)**2
    end / values.length.to_f

    Math.sqrt(variance)
  end

  def summary(values)
    {
      min: values.min,
      max: values.max,
      mean: mean(values),
      standard_deviation: standard_deviation(values)
    }
  end

  # Scales each feature using the population mean and standard deviation.
  def standardize(rows)
    n_features = rows.first.length
    means = Array.new(n_features) { |index| mean(rows.map { |row| row[index] }) }
    standard_deviations = Array.new(n_features) do |index|
      standard_deviation(rows.map { |row| row[index] })
    end
    scaled = rows.map do |row|
      row.each_index.map do |index|
        (row[index] - means[index]) / standard_deviations[index]
      end
    end

    [scaled, means, standard_deviations]
  end
end
