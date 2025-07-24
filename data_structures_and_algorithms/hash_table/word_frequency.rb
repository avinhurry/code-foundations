require_relative 'chaining/chaining'
table = HashTable::Chaining.new

filename = ARGV[0] || 'sample.txt'

File.foreach(filename) do |line|
  line.downcase.scan(/\b[\w']+\b/) do |word|
    count = table.get(word) || 0
    table.set(word, count + 1)
  end
end

# Simple output
('a'..'z').each do |letter|
  puts "--- #{letter.upcase} ---"
  (0...table.instance_variable_get(:@size)).each do |i|
    bucket = table.instance_variable_get(:@buckets)[i]
    next unless bucket.is_a?(Array)
    bucket.each do |key, val|
      puts "#{key}: #{val}" if key.start_with?(letter)
    end
  end
end

# Run with: `ruby data_structures/hash_table/word_frequency.rb data_structures/hash_table/sample.txt`
