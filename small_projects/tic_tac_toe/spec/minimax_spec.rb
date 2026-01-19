# frozen_string_literal: true

require_relative '../app/minimax'
RSpec.describe Minimax do
  let(:ai) { Minimax.new }

  describe '#best_move' do
    it 'chooses the winning move for X' do
      board = [
        :X, :X, nil,
        :O, :O, nil,
        nil, nil, nil
      ]
      expect(ai.best_move(board)).to eq(2)
    end

    it 'blocks O from winning' do
      board = [
        :X, nil, nil,
        :O, :O, nil,
        :X, nil, nil
      ]
      expect(ai.best_move(board)).to eq(5)
    end

    it 'chooses the best move in a complex scenario' do
      board = [
        :X, :O, :X,
        :X, :O, nil,
        nil, nil, :O
      ]
      expect(ai.best_move(board)).to eq(6)
    end

    it 'chooses a corner or center on an empty board' do
      board = Array.new(9, nil)
      expect([0, 2, 4, 6, 8]).to include(ai.best_move(board))
    end

    it 'chooses the only available move' do
      board = [:X, :O, :X,
               :X, :O, :O,
               :O, :X, nil]
      expect(ai.best_move(board)).to eq(8)
    end

    it 'creates a winning fork when possible' do
      board = [
        nil, nil, nil,
        nil, :O, nil,
        nil, nil, :X
      ]
      expect([0, 2]).to include(ai.best_move(board))
    end

    it 'prevents opponent from creating a fork' do
      board = [
        :O, nil, nil,
        nil, :X, nil,
        nil, nil, :O
      ]
      expect([1, 3, 5, 7]).to include(ai.best_move(board))
    end
  end
end
