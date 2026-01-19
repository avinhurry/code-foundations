class RedBlackNode
  attr_accessor :key, :value, :left, :right, :parent, :colour

  def initialize(key:, value:, left: nil, right: nil, parent: nil, colour: :red)
    @key = key
    @value = value
    @left = left
    @right = right
    @parent = parent
    @colour = colour
  end

  def red?
    @colour == :red
  end

  def black?
    @colour == :black
  end

  def grandparent
    parent&.parent
  end

  def uncle
    return unless grandparent

    if parent == grandparent.left
      grandparent.right
    else
      grandparent.left
    end
  end
end