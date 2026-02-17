class NPuzzle
  attr_reader :size, :state

  def initialize(start_state)
    @size = Math.sqrt(start_state.size).to_i
    @state = start_state.dup
  end

  def blank_index
    state.index(0)
  end
end