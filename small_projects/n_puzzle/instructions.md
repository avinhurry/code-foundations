# N-puzzle

Design an **N-Puzzle Solver** (e.g. 8-puzzle / 15-puzzle) using backtracking.

An **N-puzzle** is a family of sliding tile puzzles played on a square grid with **one** empty space. The most common versions are the **8-puzzle** (3×3 board, 8 tiles) and the **15-puzzle** (4×4 board, 15 tiles).

## Definition

- You have an m×m board (e.g. 3×3, 4×4).
- There are N = m^2 - 1 square tiles, usually numbered 1 to N, plus **one empty space** (represented as `0`).
- The tiles start in a **scrambled** arrangement.
- The **goal** is to reach a target arrangement, typically putting the numbers in order in row-major order with the empty space in the last position.

Example **goal state** for 8-puzzle (3×3):

```ruby
1 2 3
4 5 6
7 8 0
```

Example **goal state** for 15-puzzle (4×4):

```ruby
 1  2  3  4
 5  6  7  8
 9 10 11 12
13 14 15  0
```

**Here `0` denotes the empty cell!**

## Rules

1. **You may only slide a tile that is orthogonally adjacent to the empty space (`0`).**
    - Valid moves: Up, Down, Left, Right (i.e. swap the blank with the neighboring tile in that direction).
    - No diagonal moves.
    - Only one tile is moved per step.
2. Each move creates a new board configuration by swapping the empty cell with a neighbor.
3. The puzzle is **solved** when the board matches the agreed target configuration (usually sorted order, blank at the end).
4. Not every random configuration is solvable: for a given board size, **only about half of all possible permutations** can be solved (they are split into two parity classes).

## Examples of Start / Goal States

```ruby
1 3 2
5 6 7
0 4 8
```

Goal:

```ruby
1 2 3
4 5 6
7 8 0
```

## Example 2: 15-Puzzle (4×4)

**Start state:**

```ruby
 1  2  3  4
 5  6  7  8
 9 10  0 12
13 14 11 15
```

Goal:

```ruby
 1  2  3  4
 5  6  7  8
 9 10 11 12
13 14 15  0
```

## Input / Output Format

Input:
- An m×m grid of integers, one row per line, space-separated.
- 0 represents the blank tile.

Example input (3×3):

```ruby
1 2 3
4 0 6
7 5 8
```

Output:
- A sequence of moves using the words Up, Down, Left, Right.
- If no solution, output `unsolvable`.

## Project Brief

Build a Ruby class that:

- Reads an N-puzzle configuration from input (e.g. 3×3 or 4×4 grid).
- Uses backtracking (depth-first search with undo) to explore moves.
- Detects and prunes already-visited states to avoid infinite loops.
- Returns a sequence of moves (Up, Down, Left, Right) that transforms the start state into the goal state, or reports `unsolvable`.

Focus on:

- Representing state (array of arrays or 1D array).
- Generating valid next moves from current blank position.
- Backtracking: apply move → recurse → undo move.
- Visited set (e.g. `Set` of serialized boards) to prune.

## Requirements

1. Support at least **8-puzzle (3×3)** and ideally **15-puzzle (4×4)**.
2. Implement:
    - `neighbors(state)` to generate next valid states.
    - `solve(start_state, goal_state)` using backtracking.
3. Limit search depth or node count to avoid hanging.
4. Add specs!

```ruby
class NPuzzle
  attr_reader :size, :start_state, :goal_state

  # state is a 1D array, e.g. [1,2,3,4,5,6,7,8,0] for 3×3
  def initialize(start_state)
  end
  
  # your code
end
```

Example output:

```ruby
Start state:
 1  2  3
 4  0  6
 7  5  8

Neighbor states from start:

Move 1:
 1  0  3
 4  2  6
 7  5  8

Move 2:
 1  2  3
 4  5  6
 7  0  8

Move 3:
 1  2  3
 4  5  6
 7  8  0

.
.
.

Goal state:
 1  2  3
 4  5  6
 7  8  0
```