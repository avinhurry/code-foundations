require_relative 'red_black_node'

class RedBlackTree
  attr_accessor :root

  def initialize
    @root = nil
  end

  def insert(key, value)
    new_node = RedBlackNode.new(key:, value:)

    if root.nil?
      @root = new_node
      new_node.colour = :black
    else
      insert_recursive(root, new_node)
    end

    fix_insert(new_node)
  end

  def find(key)
    current = root
    while current
      return current.value if key == current.key

      current = key < current.key ? current.left : current.right
    end
    nil
  end

  private

  def insert_recursive(current, new_node)
    if new_node.key < current.key
      if current.left.nil?
        current.left = new_node
        new_node.parent = current
      else
        insert_recursive(current.left, new_node)
      end
    elsif current.right.nil?
      current.right = new_node
      new_node.parent = current
    else
      insert_recursive(current.right, new_node)
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
        gp = node.grandparent

        if node == node.parent.right && node.parent == gp.left
          # Case 2: left to right
          rotate_left(node.parent)
          node = node.left
        elsif node == node.parent.left && node.parent == gp.right
          # Case 2 (mirror): right to left

          rotate_right(node.parent)
          node = node.right
        end

        # Case 3: straight line
        node.parent.colour = :black
        gp.colour = :red

        if node == node.parent.left
          rotate_right(gp)
        else
          rotate_left(gp)
        end
      end
    end

    root.colour = :black
  end

  def rotate_left(pivot)
    # new_root is assigned to the right child of the pivot
    new_root = pivot.right

    # Move new_roots left child to pivots right
    pivot.right = new_root.left
    new_root.left.parent = pivot if new_root.left

    # Link new_root to pivots parent
    new_root.parent = pivot.parent

    if pivot.parent.nil?
      # Pivot was root so update tree root
      self.root = new_root
    elsif pivot == pivot.parent.left
      # Pivot was a left child, reattach new_root there
      pivot.parent.left = new_root
    else
      # Pivot was a right child, reattach new_root there
      pivot.parent.right = new_root
    end

    # Move pivot below new_root
    new_root.left = pivot
    # Update pivots parent to point to new root
    pivot.parent = new_root
  end

  def rotate_right(pivot)
    # new_root is assigned to the left child of the pivot
    new_root = pivot.left

    # Move new_root's right child to pivot's left
    pivot.left = new_root.right
    new_root.right.parent = pivot if new_root.right

    # Link new_root to pivots parent
    new_root.parent = pivot.parent

    if pivot.parent.nil?
      # Pivot was root so update tree root
      self.root = new_root
    elsif pivot == pivot.parent.right
      # Pivot was a right child, reattach new_root there
      pivot.parent.right = new_root
    else
      # Pivot was a left child, reattach new_root there
      pivot.parent.left = new_root
    end

    # Move pivot below new_root
    new_root.right = pivot
    # Update pivots parent to point to new root
    pivot.parent = new_root
  end
end
