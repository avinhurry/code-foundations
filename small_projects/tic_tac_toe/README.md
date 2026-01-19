# Tic-Tac-Toe in Ruby

A command-line Tic-Tac-Toe game that pairs a Minimax-based AI with a custom Red-Black Tree cache for performant, unbeatable play.

## Setup

```bash
bundle install
```

## Running

```bash
bundle exec ruby bin/play.rb
```

## Features

- Human vs AI using Minimax with cached states
- Red-Black Tree-based cache (`DecisionTree`) for previously evaluated board states
- Minimal terminal UI that works without additional dependencies beyond `terminal-table` (specified in `gemfile`)
