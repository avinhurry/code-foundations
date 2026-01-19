# frozen_string_literal: true

require_relative '../app/tic_tac_toe'
RSpec.describe TicTacToe do
  let(:game) { TicTacToe.new }
  describe '#make_move' do
    it 'allows a valid move' do
      expect(game.make_move(0)).to be true
    end

    it 'rejects an invalid move (out of bounds)' do
      expect(game.make_move(9)).to be false
    end

    it 'rejects a move to an occupied position' do
      game.make_move(0)
      expect(game.make_move(0)).to be false
    end
  end

  describe '#winner' do
    it 'returns nil when there is no winner' do
      expect(game.winner).to be_nil
    end

    it 'returns the winning player when a player wins' do
      game.make_move(0)
      game.make_move(3)
      game.make_move(1)
      game.make_move(4)
      game.make_move(2)
      expect(game.winner).to eq(:X)
    end
  end

  describe '#game_over?' do
    it 'returns false when the game is not over' do
      expect(game.game_over?).to be false
    end

    it 'returns true when there is a winner' do
      game.make_move(0)
      game.make_move(3)
      game.make_move(1)
      game.make_move(4)
      game.make_move(2)
      expect(game.game_over?).to be true
    end

    it 'returns true when the board is full' do
      moves = [0, 1, 2, 4, 3, 5, 7, 6, 8]
      moves.each { |pos| game.make_move(pos) }
      expect(game.game_over?).to be true
    end
  end

  describe '#available_moves' do
    it 'returns all available moves on a new board' do
      expect(game.available_moves).to eq([0, 1, 2, 3, 4, 5, 6, 7, 8])
    end
  end
end
