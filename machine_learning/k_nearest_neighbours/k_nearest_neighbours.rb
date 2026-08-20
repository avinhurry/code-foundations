class KNearestNeighbours
  def initialize(k:)
    @k = k
  end

  # Measures how far apart two feature arrays are using Euclidean distance.
  def distance(a, b)
    Math.sqrt(a.each_index.sum { |index| (a[index] - b[index])**2 })
  end

  # Finds the nearest neighbours and returns the label with the most votes.
  def classify(query, data)
    data
      .sort_by { |features, _label| distance(query, features) }
      .first(@k)
      .map { |_features, label| label }
      .group_by(&:itself)
      .max_by { |_label, votes| votes.length }
      .first
  end

  # Finds the nearest neighbours and returns the average of their numeric target values.
  def regress(query, data)
    values = data
      .sort_by { |features, _value| distance(query, features) }
      .first(@k)
      .map { |_features, value| value }

    values.sum.to_f / values.length
  end

  # Gives closer neighbours a larger vote using inverse distance weighting.
  def weighted_classify(query, data)
    neighbours = data
      .sort_by { |features, _label| distance(query, features) }
      .first(@k)

    votes = Hash.new(0.0)
    neighbours.each do |features, label|
      neighbour_distance = distance(query, features)
      votes[label] += 1.0 / (neighbour_distance + 1e-9)
    end

    votes.max_by { |_label, weight| weight }.first
  end
end