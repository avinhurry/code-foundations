class NPuzzle
  attr_reader :size, :state

  def initialize(start_state)
    @size = Math.sqrt(start_state.size).to_i
    @state = start_state.dup
  end

  def blank_index
    state.index(0)
  end

  def row(index)
    index / size
  end

  def column(index)
    index % size
  end

  def valid_moves
    moves = []

    i = blank_index
    r = row(i)
    c = column(i)

    moves << :up if r > 0
    moves << :down if r < size - 1
    moves << :left if c > 0
    moves << :right if c < size - 1

    moves
  end

  def swap!(i, j)
    state[i], state[j] = state[j], state[i]
  end

  def apply_move!(move)
    i = blank_index

    case move
    when :up
      swap!(i, i - size)
    when :down
      swap!(i, i + size)
    when :left
      swap!(i, i - 1)
    when :right
      swap!(i, i + 1)
    end
  end
end