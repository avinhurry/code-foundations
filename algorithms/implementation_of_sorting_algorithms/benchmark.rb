# Benchmarking 

@best_case ||= [*0..1000]
@worst_case ||= @best_case.reverse
@random_case ||= Array.new(1000) { rand(101) }




Benchmark.bm(10) do |x|

  # Bubble sort
  x.report("Bubble Best:") { Collection.new(@best_case).bubble_sort }
  x.report("Bubble Worst:") { Collection.new(@worst_case).bubble_sort }
  x.report("Bubble Random:") { Collection.new(@random_case).bubble_sort }

  # Insertion sort
  x.report("Insertion Best:") { Collection.new(@best_case).insertion_sort }
  x.report("Insertion Worst:") { Collection.new(@worst_case).insertion_sort }
  x.report("Insertion Random:") { Collection.new(@random_case).insertion_sort }

  # selection_sort
  x.report("Selection Best:") { Collection.new(@best_case).selection_sort }
  x.report("Selection Worst:") { Collection.new(@worst_case).selection_sort }
  x.report("Selection Random:") { Collection.new(@random_case).selection_sort }

  # merge_sort
  x.report("Merge Best:") { Collection.new(@best_case).merge_sort }
  x.report("Merge Worst:") { Collection.new(@worst_case).merge_sort }
  x.report("Merge Random:") { Collection.new(@random_case).merge_sort }

  # Quick sort
  x.report("Quick Best:") { Collection.new(@best_case).quick_sort }
  x.report("Quick Worst:") { Collection.new(@worst_case).quick_sort }
  x.report("Quick Random:") { Collection.new(@random_case).quick_sort }
end