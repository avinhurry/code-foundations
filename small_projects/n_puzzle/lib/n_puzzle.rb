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

    r = row(blank_index)
    c = column(blank_index)

    moves << :up if r > 0
    moves << :down if r < size - 1
    moves << :left if c > 0
    moves << :right if c < size - 1

    moves
  end
end