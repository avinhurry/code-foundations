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
end