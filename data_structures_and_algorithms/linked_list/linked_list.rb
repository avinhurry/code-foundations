class LinkedList
  attr_accessor :head

  def initialize
    @head = nil
  end

  def insert(value)
    if head.nil?
      @head = Node.new(value, nil)
      return
    end

    last_node = @head
    last_node = last_node.next_node while last_node.next_node

    last_node.next_node = Node.new(value, nil)
  end

  def search(value)
    node = @head

    while node
      return true if node.value == value

      node = node.next_node
    end

    false
  end

  def delete(value)
    return if head.nil?

    # Case 1: value is at the head
    if head.value == value
      self.head = head.next_node
      return
    end

    # Case 2: value is somewhere else
    prev = head
    current = head.next_node

    while current
      if current.value == value
        prev.next_node = current.next_node
        return
      end

      prev = current
      current = current.next_node
    end
  end

  class Node
    attr_accessor :value, :next_node

    def initialize(value, next_node)
      @value = value
      @next_node = next_node
    end
  end
end
