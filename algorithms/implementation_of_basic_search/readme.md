# Description of search algorithm 

Interpolation search is an improved version of binary search (which searches by cutting the search space in half).
Interpolation search works well when the data is uniformly distributed. Instead of always checking the middle element
(as in binary search), interpolation search estimates the position of a target using a formula similar to the way you'd 
estimate where a number falls in the sorted list.

Imagine looking for a word in a dictionary. Instead of opening it exactly in the middle (Binary Search), you estimate 
where the word might be based on its first letter and jump closer to the actual position.

## High-Level Explanation

- Binary search divides the search space in half each time.

- Interpolation search tries to "guess" where the target might be based on its value relative to the range of the data.

