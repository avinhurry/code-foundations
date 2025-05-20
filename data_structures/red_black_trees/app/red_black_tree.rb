require_relative 'red_black_node'

class RedBlackTree
  attr_accessor :root

  def initialize
    @root = nil
  end

  def insert(value)
    new_node = RedBlackNode.new(value:)

    if root.nil?
      @root = new_node
      new_node.colour = :black
    else
      insert_recursive(root, new_node)
    end

    fix_insert(new_node)
  end

  private

  def insert_recursive(current, new_node)
    if new_node.value < current.value
      if current.left.nil?
        current.left = new_node
        new_node.parent = current
      else
        insert_recursive(current.left, new_node)
      end
    else
      if current.right.nil?
        current.right = new_node
        new_node.parent = current
      else
        insert_recursive(current.right, new_node)
      end
    end
  end 
  
  def fix_insert(node)
    while node != root && node.parent.colour == :red
      if node.uncle&.colour == :red
        # Case 1: parent and uncle are red then recolour
        node.parent.colour = :black
        node.uncle.colour = :black
        node.grandparent.colour = :red
        node = node.grandparent
      else
        # Cases 2 & 3 will go here later
        break
      end
    end

    root.colour = :black
  end
end