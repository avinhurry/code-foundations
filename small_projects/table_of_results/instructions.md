# Deliver on 16th January


### **Project Description:**

---

You will build a Ruby program that generates a table of results.

---

### **Initial Requirement:**

Create a program that:

1. Prints a table where:
    - The **X-axis** contains numbers from 1 to 10 (include zero).
    - The **Y-axis** contains the first 10 prime numbers (include zero).
    - Each cell in the table is the product of  and  (multiplication). - you add table formatting “——” or “===”
        
        xx
        
        yy
        
2. **Example Output:**
    
    ```
           1    2    3    4    5    6    7    8    9   10
      2    2    4    6    8   10   12   14   16   18   20
      3    3    6    9   12   15   18   21   24   27   30
      5    5   10   15   20   25   30   35   40   45   50
      7    7   14   21   28   35   42   49   56   63   70
     11   11   22   33   44   55   66   77   88   99  110
     13   13   26   39   52   65   78   91  104  117  130
     17   17   34   51   68   85  102  119  136  153  170
     19   19   38   57   76   95  114  133  152  171  190
     23   23   46   69   92  115  138  161  184  207  230
     29   29   58   87  116  145  174  203  232  261  290
    
    ```
    

---

- It is a command line so this print should be on the terminal

The program should be run like these:

```bash
ruby table_generator.rb
```

---

### **What to Expect:**

1. **Testing:** Include tests to validate your program's functionality. You can use any testing framework, such as RSpec or Cucumber, etc.
2. **No External Gems:** The program must not rely on any external gems or libraries—use only Ruby's standard library.
3. **Version Control:** Use Git to manage your project. Ensure each meaningful change is committed with a clear, descriptive commit message. I will review your logic and approach through your Git commit history.
- **Explanation:** Next year, you will explain your solution to me. Focus on articulating the *why* behind your implementation.

---

### Progressive Features to Challenge Code Design

1) **Switchable Operations**
    - Support addition, subtraction, and division instead of just multiplication.

2) **Custom Sequences**

    - Be able to customise primes (the y-axis) with other sequences Fibonacci, even, or odd numbers, Exponential sequence (e.g., 2, 4, 8, 16), chosen all via command-line options.

    - Be able to customize the x-axis (any range). e.g from 0 to 10, from 100 to 110.

3) **Formatting**

    - Add options for different styles (e.g., CSV, Markdown).

4) **Output Customization**