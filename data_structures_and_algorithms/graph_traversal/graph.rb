class Graph
  def initialize
    # Create a hash with a default block so that when you access a key that doesn't exist, it automatically creates it and assigns a new empty value
    @adjacency = Hash.new { |h, k| h[k] = [] }
  end

  def add_edge(node1, node2)
    # Adds an undirected edge between two nodes, creating entries if needed
    @adjacency[node1] << node2
    @adjacency[node2] << node1
  end

  def breadth_first_search(start)
    # set is like an array but faster and does not allow duplicates. Without this you'd visit the same node multiple times and possibly create an infinite loop.
    visited = Set.new

    # Start the queue with the initial node
    queue = [start]

    # We store the order of visited nodes here
    result = []

    # While there are still nodes in the queue, take the first one (FIFO) and assign it to `node`.
    # If we've already visited this node, skip it.
    # Otherwise, mark it as visited and add it to the result list.
    while queue.any?
      node = queue.shift
      next if visited.include?(node)

      visited << node
      result << node

      # Add this node's neighbors to the queue so we can visit them later
      queue.concat(@adjacency[node])
    end

    # Return the results, which is the order in which nodes were visited
    result
  end

  def depth_first_search(start)
    # A Set is like an array but faster and does not allow duplicates. Without this you'd visit the same node multiple times and possibly create an infinite loop.
    visited = Set.new

    # Start the stack with the initial node
    stack = [start]

    # We store the order of visited nodes here
    result = []

    # While there are still nodes in the stack, take the last one (LIFO) and assign it to `node`.
    # If we've already visited this node, skip it.
    # Otherwise, mark it as visited and add it to the result list.
    while stack.any?
      node = stack.pop
      next if visited.include?(node)

      visited << node
      result << node

      # Add this node's neighbors to the stack so we can visit them later
      # We reverse the list so that lower numbered neighbors are visited first
      stack.concat(@adjacency[node].reverse)
    end

    # Return the results, which is the order in which nodes were visited
    result
  end

  def adjacency
    @adjacency
  end

  alias bfs breadth_first_search
  alias dfs depth_first_search
end
