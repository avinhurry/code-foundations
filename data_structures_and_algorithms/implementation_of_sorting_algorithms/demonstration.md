# Sorting Algorithms Demo

## Bubble Sort

This is when you look at the number to the right and check if its greater or less than the number you are on. If it's greater than you continue, if it's less then you swap it:

```mermaid
graph TD
    A[Initial Array: 3 2 5] --> B[Compare 3 and 2]
    B --> C{Swap?}
    C -->|Yes| D[Array after swap: 2 3 5]
    D --> E[Compare 3 and 5]
    E --> F{Swap?}
    F -->|No| G[Array after pass 1: 2 3 5]
    G --> H[Is array sorted?]
    H -->|Yes| I[End: Sorted array is 2 3 5]
```

## Insertion Sort

This is when you look at the elements to the left and compare them, if the element to the left is greater than the element you are on, you shift it to the right. You keep doing this until the current element can be inserted in the correct position because it is greater than or = to that number.

This keeps happening until all the elements are in the correct order.

You start on the second element because there is nothing to the left of the first element.

```mermaid
graph TD
    A[Initial Array: 3 2 5] --> B[Pass 1: Take 2 and compare with 3]
    B --> C{Is 2 < 3?}
    C -->|Yes| D[Insert 2 before 3: 2 3 5]
    D --> E[Pass 2: Take 5 and compare with 3]
    E --> F{Is 5 < 3?}
    F -->|No| G[5 stays in place: 2 3 5]
    G --> H[Array is sorted]
    H --> I[End: Sorted array is 2 3 5]
```

## Selection sort

This works by scanning the array, searching for the smallest number and swapping it with the first unsorted number. For example [3, 2, 5]. The first unsorted number is 3 and scanning the array 2 is the smallest so 2 would be swapped with 3. This will repeat for everything in the list until everything is sorted.

```mermaid
graph TD
    A[Initial Array: 3 2 5] --> B[Pass 1: Take 3 and scan for the smallest]
    B --> C[Smallest found: 2]
    C --> D[Swap 2 and 3: 2 3 5]
    D --> E[Pass 2: Take 3 and scan for the smallest in the remaining unsorted portion]
    E --> F{Smallest is 3}
    F -->|Yes| G[3 stays in place]
    G --> H[Pass 3: Only 5 remains, no swaps needed]
    H --> I[Array is sorted: 2 3 5]
```

## Merge sort

This works by dividing the array into halves and sorting then combining the arrays back together again. This is done using recursion to (calling merge_sort inside itself) until we get to arrays with 1 or 0 elements.


```mermaid
graph TD
    A[Initial Array: 3, 2, 5] --> B[Divide into two halves: 3 and 2, 5]
    B --> C[Divide second half: 2 and 5]
    C --> D[Subarrays of 1 element: 3, 2, 5]
    D --> E[Merge 2 and 5 to form: 2, 5]
    E --> F[Merge 3 and 2, 5 to form: 2, 3, 5]
    F --> G[Array is fully sorted]
```

## Quick sort 

This works by picking a pivot, partitioning the array into elements smaller and larger than the pivot and then recursively sorting each side.

```mermaid
graph TD
    A[Initial Array: 3, 2, 5] --> B[Pick a pivot: 2]
    B --> C[Partition array: Elements smaller or equal to pivot 2 and larger than pivot 3, 5]
    C --> D[Left subarray: 2]
    D --> E[Right subarray: 3, 5]
    E --> F[Pick pivot for right subarray: 3]
    F --> G[Partition right subarray: 3 and 5]
    G --> H[Left subarray: 3, Right subarray: 5]
    H --> I[Subarrays are now sorted]
    I --> J[Final sorted array: 2, 3, 5]
```