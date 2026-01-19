# frozen_string_literal: true

require_relative '../app/decision_tree'
RSpec.describe DecisionTree do
  let(:tree) { DecisionTree.new }
  
  describe '#insert' do
    it 'inserts and retrieves board state scores' do
    tree.insert('X-O-X--OX', 10)
    tree.insert('XOXOXO---', -10)
    tree.insert('---------', 0)

    expect(tree.find('X-O-X--OX')).to eq(10)
    expect(tree.find('XOXOXO---')).to eq(-10)
    expect(tree.find('---------')).to eq(0)
  end
  end
end
