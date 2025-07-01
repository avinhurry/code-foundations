**Project Specification: Tic-Tac-Toe with basic AI using Red-Black Trees**

**Objective**: Build a Ruby Tic-Tac-Toe game where an unbeatable AI uses Minimax with Red-Black Tree caching.

## **1. Game Rules**

1. **Board**: 3x3 grid (positions 0-8).
2. **Players**:
    - Human (`O`)
    - AI (`X`)
3. **Winning**: A player wins by placing 3 marks in a row, column, or diagonal.
4. **Turns**: Players alternate turns, starting with `X` (AI).
5. **Draw**: All cells filled with no winner.

## **2. Technical Requirements**

## **Class Diagram**

```ruby
┌───────────────────┐        ┌───────────────────┐        ┌───────────────────┐  
│    TicTacToe      │        │     Minimax       │        │  DecisionTree     │  
├───────────────────┤        ├───────────────────┤        ├───────────────────┤  
│ - board           │        │ - cache (Decision │        │ - insert(key, val)│  
│ - current_player  │        │   Tree)           │        │ - find(key)       │  
├───────────────────┤        ├───────────────────┤        └───────────────────┘  
│ + print_board()   │        │ + best_move(board)│  
│ + make_move(pos)  │        │                   │  
│ + winner?()       │        │                   │  
│ + game_over?()    │        └───────────────────┘  
└───────────────────┘  
```

## **Class Interfaces**

## **`TicTacToe`**

- `print_board()`: Displays the board with position numbers (0-8) in empty cells.
- `make_move(pos)`: Places `current_player`'s mark at `pos` if valid.
- `winner?()`: Returns `:X`, `:O`, or `nil`.
- `game_over?()`: Returns `true` if game ended.
- `available_moves()`: Returns array of valid positions (e.g., `[0,X]`)

## **`Minimax`**

- `best_move(board)`: Returns optimal move (0-8) for AI using Minimax.
- Uses `DecisionTree` to cache board states and scores.

## **`DecisionTree`**

- `insert(key, value)`: Stores board state (e.g., `"X-O-X-O-X"`) and its Minimax score.
- `find(key)`: Returns cached score or `nil`.

**Class Interface Examples**

Below are the **public method signatures** with usage examples and expected returns. No implementation code is provided—only usage patterns.

## **1. `TicTacToe` Class**

Manages the game board and player turns.

```ruby
class TicTacToe  
  # Initializes a 3x3 board and sets current player to :X (AI).  
  def initialize; end  

  # Prints the board with position numbers (0-8) in empty cells.  
  # Example:  
  #   game.print_board  
  #   # => Prints a formatted 3x3 grid with numbers or symbols.  
  def print_board; end  

  # Places the current player's mark at `pos` if valid.  
  # Example:  
  #   game.make_move(4) # => true (success)  
  #   game.make_move(4) # => false (position taken)  
  def make_move(pos); end  

  # Returns the winner (:X, :O) or nil.  
  # Example:  
  #   game.winner? # => :X  
  def winner?; end  

  # Returns true if the game is over (win or draw).  
  # Example:  
  #   game.game_over? # => true  
  def game_over?; end  

  # Returns an array of available moves (0-8).  
  # Example:  
  #   game.available_moves # => [0, 2, 6]  
  def available_moves; end  
end
```

## **2. `Minimax` Class**

Implements the AI decision-making logic.

```ruby
class Minimax  
  *# Initializes with a DecisionTree for caching.*  
  def initialize; end  

  *# Returns the optimal move (0-8) for the AI.  
  # Example:  
  #   ai.best_move([:X, nil, :O, nil, :X, nil, nil, nil, nil]) # => 4*  
  def best_move(board); end  
end
```

## **3. `DecisionTree` Class**

Caches board states and scores using a Red-Black Tree.

```ruby
class DecisionTree  
  *# Inserts a board state (string) and its Minimax score.  
  # Example:  
  #   tree.insert("X-O-X-O-X", 10) 
  # => nil (no return)*  
  def insert(key, value); end  

  *# Returns the cached score for a board state or nil.  
  # Example:  
  #   tree.find("X-O-X-O-X") # => 10*  
  def find(key); end  
end
```

**Key Notes for Implementation**:

1. **Red-Black Tree Balancing**: Ensure `insert` triggers rotations and recoloring.
2. **Terminal Display**: Use `terminal-table` for clean board formatting.
3. **Testing**: Validate AI behavior with precomputed optimal moves (e.g., forced wins/blocks).

## **3. Red-Black Tree Requirements**

- **Purpose**: Cache board states to avoid redundant Minimax calculations.
- **Methods**:
    - `insert()` with automatic rebalancing (rotations + recoloring).
    - `find()` with O(log n) time complexity.

## **4. Testing Specs**

Verify AI behavior with deterministic scenarios:

## **Spec 1: Force Immediate Win**

```ruby
*# Board:  X | O | X  
#         O |   |  
#         X |   | O*  
game.board = [:X, :O, :X, :O, nil, nil, :X, nil, :O]  
expect(ai.best_move(game.board)).to eq(4)  *# Wins at position 4*
```

## **Spec 2: Block Opponent Win**

```ruby
*# Board:  O | O |  |
#         X | X |  |
#         O |   |  |*
game.board = [:O, :O, nil, :X, :X, nil, :O, nil, nil]  
expect(ai.best_move(game.board)).to eq(2)  *# Blocks O's win*
```

## **Spec 3: Optimal First Move**

```ruby
*# Empty board*  
expect([0, 2, 4, 6, 8]).to include(ai.best_move(Array.new(9, nil)))
```

## **Spec 4: Create Winning Fork**

```ruby
  |   |  
  |   |  
  |   | X 
```

**Explanation**:

- AI (X) places in the center (4), creating potential wins via rows, column

```ruby
*# Board:    |   |  
#           | O |  
#           |   | X*  
game.board = [nil, nil, nil, nil, :O, nil, nil, nil, :X]  
expect(ai.best_move(game.board)).to eq(4)  *# Centers to create two winning paths*
```

## **Spec 5: Block Opponent Fork / Avoid Traps**

**Explanation**:

- AI (X) must choose a side (1, 3, 5, or 7) to prevent O from creating two winning paths.

```ruby
*# Board:  O |   |  
#           | X |  
#           |   | O*  
game.board = [:O, nil, nil, nil, :X, nil, nil, nil, :O]  
expect([1,3,5,7]).to include(ai.best_move(game.board))  *# Blocks O's potential fork (1, 3, 5, or 7)*
```

## **Spec 6: Force Draw**

```ruby
# X | O | X  
# O | X | O  
# O | X |   
game.board = [:X, :O, :X, :O, :X, :O, :O, :X, nil]  
expect(ai.best_move(game.board)).to eq(8)  # Only valid move (position 8)  
```

Other example:

```ruby
# X | O | X  
# X | O | O  
# O |   | X  

game.board = [:X, :O, :X, :X, :O, :O, :O, nil, :X]  
expect(ai.best_move(game.board)).to eq(7)  # Only valid move (draw)  
```

## **Spec 7: Win in Two Moves**

```ruby
*# Board:  X | O |  
#           | X |  
#           | O |*  
game.board = [:X, :O, nil, nil, :X, nil, nil, :O, nil]  
expect(ai.best_move(game.board)).to eq(6)  *# Wins in 2 moves (6 → 8)*
```

## **5. Minimax help!**

## Step-by-Step Example: Minimax Algorithm in Tic-Tac-Toe

Let’s walk through the Minimax algorithm for the following board state, where it’s **X’s turn** (AI) to play:

```ruby
X |   |  
  | O |  
  |   | X
```

## Step 1: Generate Possible Moves

The AI (X) can choose positions **1, 3, 5, 6, or 7**.

## Step 2: Evaluate Each Move

We’ll simulate each move and calculate its score using Minimax.

## Move 1: X at Position 1

**New Board:**

```ruby
X | X |  
  | O |  
  |   | X
```

**Opponent’s Turn (O):**

- O chooses position 3 (to block):

```ruby
X | X | O  
  | O |  
  |   | X`
```

**AI’s Turn (X):**

- X chooses position 5:

```ruby
X | X | O  
  | O | X  
  |   | X`
```

**Result:** No winner.

**Score:** 0 (draw)

## Move 2: X at Position 3

**New Board:**

```ruby
X |   |  
X | O |  
  |   | X`
```

**Opponent’s Turn (O):**

- O chooses position 1 (to block):

```ruby
X | O |  
X | O |  
  |   | X
```

**AI’s Turn (X):**

- X chooses position 6:

```ruby
X | O |  
X | O |  
X |   | X
```

**Result:** X wins.

**Score:** +10

## Move 3: X at Position 5

**New Board:**

```ruby
X |   |  
  | O | X  
  |   | X`
```

**Opponent’s Turn (O):**

- O chooses position 3 (to block):

```ruby
X |   | 0 
  | O | X  
  |   | X`
```

**AI’s Turn (X):**

- X chooses position 6:

```ruby
X |   | 0 
  | O | X  
X |   | X`
```

**Result:** X wins in the next X move.

**Score:** +10

## Step 3: Propagate Scores

- Move 1: 0
- Move 2: +10
- Move 3: +10
- Move 4: +10
- Move 5: 0

## Step 4: Choose the Best Move

The AI selects **any move with a score of +10** (positions 3, 5, or 6).

**Final Decision:**

The AI plays **X at position 3, 5, or 6**, guaranteeing a win.

**Key Takeaway:**

Minimax evaluates all possible future moves, assuming the opponent plays optimally, to choose the path that maximizes the AI’s guaranteed outcome.

---

## **6. Deliverables**

1. Source code with:
    
    ```ruby
    .
    ├── README.md
    ├── lib
    │   ├── decision_tree.rb
    │   ├── minimax.rb
    │   └── tic_tac_toe.rb
    └── spec
        ├── decision_tree_spec.rb
        ├── minimax_spec.rb
        └── tic_tac_toe_spec.rb
    
    3 directories, 7 files
    ```
    
2. Documentation explaining choices.

**Notes**:

- Use the `terminal-table` gem for board display.
- Code must be linted (RuboCop) and tested (100% coverage).

---