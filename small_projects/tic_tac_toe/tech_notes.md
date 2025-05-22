Minimax AI with Red-Black Tree caching                                                                                                                            
                                                                                 
   The Minimax algorithm simulates all possible future moves in a game           
   (like Tic-Tac-Toe) to find the **optimal move** for the AI. It works like this:
                                                                                 
   - Maximizing Player (AI): Tries to choose moves that lead to the **highest possible score** (e.g., +10 for a win).
   - Minimizing Player (Opponent): Assumes the opponent will choose moves that lead to the **lowest possible score** (e.g., -10 for a loss).
   - The algorithm explores all possible moves recursively, alternating between these two perspectives, until it reaches a terminal state (win, loss, or draw).
                                                                                 
   Think of it as a "game tree" where the AI looks ahead at every possible move and countermove to pick the path that guarantees the best outcome, assuming the opponent plays perfectly.
                                                                                 
   Relationship with the Decision Tree (Red-Black Tree):                         
   The Decision Tree (a Red-Black Tree) acts as a cache to store scores of previously evaluated board states. Here's how they interact:
   - Before calculating a score, the Minimax algorithm checks if the current board state already exists in the Decision Tree.
   - If cached: It retrieves the precomputed score instantly.                    
   - If not cached: It calculates the score, stores it in the Decision Tree, and reuses it in future calculations.
                                                                                 
   This avoids redundant computations and speeds up the AI's decision-making.    
                                                                                 
   How Scores Are Calculated and Stored:                                         
   - Terminal States:                                                            
     - **Win**: +10 (AI wins).                                                   
     - **Loss**: -10 (Opponent wins).                                            
     - **Draw**: 0.                                                              
   - Non-Terminal States:                                                        
     - Scores are inherited from child nodes. For example:                       
       - If it's the AI's turn, it picks the **maximum score** from its children.
       - If it's the opponent's turn, it picks the **minimum score**.            
   - **Storage**:                                                                
     - Each board state (e.g., `"X-O-X-O-X"`) is stored as a **key** in the Red-Black Tree.
     - The corresponding Minimax score is stored as the **value**.               
                                                                                 
   - Generates all possible next moves.                                          
   - For each move, checks the Decision Tree for a cached score.                 
   - If not found, recursively evaluates future moves until terminal states.     
   - Stores new scores in the Decision Tree.                                     
   - Selects the move with the highest score.                                    
                                                                                 
   By caching scores, the AI avoids recalculating the same positions, making it **efficient** even for complex games. The Red-Black Tree ensures fast lookups and inserts ($$O(\log n)$$ time), keeping the AI responsive.