# Code Foundations

![License](https://img.shields.io/badge/license-MIT-green.svg)
![Ruby](https://img.shields.io/badge/ruby-3.x-red.svg)
![Status](https://img.shields.io/badge/purpose-learning-blueviolet)

Hands-on Ruby implementations of core data structures, algorithms, and small projects.

The goal is to *learn by building*: every topic includes real implementations, tests, and
notes explaining design choices, trade-offs, and behaviour.

## Contents

### Data structures & algorithms
- [Linked list](data_structures_and_algorithms/linked_list/)
- [Binary tree](data_structures_and_algorithms/binary_tree/)
- [Red-black tree (insert guide and visualisations)](data_structures_and_algorithms/red_black_trees/)
- [Hash tables: chaining vs open addressing + benchmarks](data_structures_and_algorithms/hash_table/)
- [Graph traversal: BFS & DFS with runnable examples](data_structures_and_algorithms/graph_traversal/)
- [Sorting algorithms + benchmark script](data_structures_and_algorithms/implementation_of_sorting_algorithms/)
- [Interpolation search](data_structures_and_algorithms/implementation_of_basic_search/)

### Small projects
- [Tic-tac-toe with minimax AI + caching (WIP)](small_projects/tic_tac_toe/)
- [Table generator utility](small_projects/table_of_results/)

## Running things

Ruby 3.x recommended. RSpec is used for specs.

Examples:
- Run a benchmark: `ruby data_structures_and_algorithms/hash_table/benchmark_hash_tables.rb`
- Run specs: `rspec data_structures_and_algorithms/graph_traversal/graph_spec.rb`

## Notes

Some folders include their own notes / READMEs with deeper explanations.

This repo is about exploration and building solid engineering foundations through code.
