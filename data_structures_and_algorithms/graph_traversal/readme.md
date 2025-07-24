# Graph Traversal in Ruby

This small project implements and explores two fundamental graph traversal algorithms: **Breadth-First Search (BFS)** and **Depth-First Search (DFS)**.

The goal is to deepen understanding of how these algorithms work by:

- Building a simple undirected graph from scratch
- Implementing BFS and DFS manually
- Running both algorithms on small and large graphs (up to 20 nodes)
- Writing specs to test traversal correctness

---

## 📘 What is a Graph?

A **graph** is a collection of nodes (also called vertices) and edges (connections between them).

In this project:
- The graph is **undirected**, meaning edges go both ways
- The graph is represented using an **adjacency list** (a hash where each key is a node, and its value is an array of connected nodes)

---

## 🔍 BFS vs DFS: What's the Difference?

### Breadth-First Search (BFS)

- **Explores the graph level by level**
- Uses a **queue** (FIFO)
- Always visits the **closest neighbors first**
- Guarantees the **shortest path** in unweighted graphs
- Good for: finding shortest paths, crawling social networks, spreading activation



### Depth-First Search (DFS)

- **Explores the graph as deep as possible before backtracking**
- Uses a stack (or recursion)
- Visits a full path before checking siblings
- Does not guarantee the shortest path
- Good for: exploring all paths, solving puzzles, detecting cycles


## 🧪 What's in This Project?

- `graph.rb`: A class that builds and stores an undirected graph, with traversal methods.
- `graph_spec.rb`: RSpec test file to verify correctness of traversal.
- Up to 10 specs covering graphs of different shapes and sizes.

---

## 🚀 Run the Code

To test manually:

```bash
ruby graph.rb
```

To run specs:

```bash
rspec graph_spec.rb
```

---

## ✅ Example Graph

```ruby
graph.add_edge(:a, :b)
graph.add_edge(:a, :c)
graph.add_edge(:b, :d)
```

This creates the structure:

```
    a
   / \
  b   c
  |
  d
```

```ruby
breadth_first_search(:a) # => [:a, :b, :c, :d]
depth_first_search(:a)   # => [:a, :c, :b, :d]  # (may vary based on neighbor order)
```

---

## 📚 Why Learn This?

- Graphs are everywhere: maps, social networks, web crawlers, puzzles
- BFS and DFS are essential tools in your problem-solving toolkit
- Writing them from scratch builds real understanding — not just theory
