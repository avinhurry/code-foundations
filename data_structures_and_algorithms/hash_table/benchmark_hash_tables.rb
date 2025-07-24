require 'benchmark'
require_relative 'chaining/chaining'
require_relative 'open_addressing/open_addressing'

table_size = 10_000
load_factors = [0.1, 0.3, 0.5, 0.7, 0.9]

def benchmark_table(name, table, entries)
  insert_time = Benchmark.realtime do
    entries.times { |i| table.set("key#{i}", i) }
  end

  lookup_time = Benchmark.realtime do
    entries.times { |i| table.get("key#{i}") }
  end

  { name:, insert: insert_time, lookup: lookup_time }
end

puts "| Type            | Load Factor | Insert Time (s) | Lookup Time (s) |"
puts "|-----------------|-------------|-----------------|------------------|"

load_factors.each do |factor|
  entries = (table_size * factor).to_i

  chaining = HashTable::Chaining.new(table_size)
  open = HashTable::OpenAddressing.new(table_size)

  result_c = benchmark_table("Chaining", chaining, entries)
  result_o = benchmark_table("OpenAddr", open, entries)

  puts "| #{result_c[:name].ljust(15)} |     #{factor}     |    #{'%.5f' % result_c[:insert]}    |     #{'%.5f' % result_c[:lookup]} |"
  puts "| #{result_o[:name].ljust(15)} |     #{factor}     |    #{'%.5f' % result_o[:insert]}    |     #{'%.5f' % result_o[:lookup]} |"
end
