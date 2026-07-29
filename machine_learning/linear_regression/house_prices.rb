require_relative "statistics"

DATA = [
  [[6.6, 3, 10], 62.4], [[9.1, 2, 19], 58.1], [[8.0, 5, 15], 83.3], [[3.0, 1, 9], 29.5],
  [[3.7, 5, 39], 60.8], [[8.9, 4, 0], 88.1], [[1.0, 1, 3], 24.6], [[8.4, 1, 7], 54.8],
  [[8.2, 3, 38], 56.9], [[5.2, 1, 27], 31.2], [[3.7, 1, 35], 34.1], [[3.5, 3, 8], 57.3],
  [[3.3, 5, 28], 58.9], [[5.0, 3, 14], 56.7], [[5.5, 5, 19], 76.2], [[6.0, 5, 0], 82.2],
  [[10.0, 5, 24], 88.1], [[8.1, 4, 33], 66.8], [[6.6, 3, 26], 59.1], [[9.9, 3, 6], 80.1]
].freeze

FEATURE_NAMES = %w[Size Bedrooms Age].freeze


def print_summary(name, values)
  summary = Statistics.summary(values)

  puts name
  puts "  Min: #{summary[:min]}"
  puts "  Max: #{summary[:max]}"
  puts "  Mean: #{summary[:mean].round(2)}"
  puts "  Std: #{summary[:standard_deviation].round(2)}"
  puts
end

features = DATA.map(&:first)
prices = DATA.map(&:last)

puts "Features"
puts

FEATURE_NAMES.each_with_index do |name, index|
  values = features.map { |row| row[index] }
  print_summary(name, values)
end

puts "Target"
puts

print_summary("Price", prices)
