class BinaryTree
  attr_accessor :value, :left, :right

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end

  def insert(new_value)
  # Inserts a new value into the binary tree.
  # If the new value is less than the current node's value, it goes to the left.
  # If the left child exists, recursively insert into it; otherwise, create a new left child.
  # If the new value is greater than or equal to the current node's value, do the same on the right side.

    if new_value < value
      @left ? @left.insert(new_value) : @left = BinaryTree.new(new_value)
    else
      @right ? @right.insert(new_value) : @right = BinaryTree.new(new_value)
    end  
  end

  def in_order_traversal
    # In-order traversal (left -> root -> right).
    # This visits the left subtree first, then the current node, then the right subtree.
    # For binary search trees, this will return the values in sorted order.

    result = []

    result += @left.in_order_traversal if @left
    result << value

    result += @right.in_order_traversal if @right
    result
  end
  
  def in_level_traversal
    # In-level traversal (also known as level-order traversal or breadth-first search).
    # This visits all nodes one level at a time from top to bottom, left to right.
    # It uses a queue to keep track of which nodes to visit next.
 

    result = []

    queue = [self]

    until queue.empty?
      current = queue.shift
      result << current.value
      queue << current.left if current.left
      queue << current.right if current.right
    end

    result
  end
end