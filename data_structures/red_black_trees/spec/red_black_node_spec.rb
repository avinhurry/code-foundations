require 'rspec'
require './app/red_black_node.rb'

RSpec.describe RedBlackNode do
  let(:red_node) { described_class.new(value: 10) }
  let(:black_node) { described_class.new(value: 20, colour: :black) }
  
  it 'defaults to red' do
    expect(red_node.colour).to eq(:red)
    expect(red_node.red?).to be true
    expect(red_node.black?).to be false
  end

  it 'can be initialized as black' do
    expect(black_node.colour).to eq(:black)
    expect(black_node.red?).to be false
    expect(black_node.black?).to be true
  end

  describe '#grandparent and #uncle' do
    let(:grandparent) { described_class.new(value: 50) }
    let(:parent) { described_class.new(value: 30, parent: grandparent) }
    let(:uncle) { described_class.new(value: 70, parent: grandparent) }
    let(:node) { described_class.new(value: 20, parent:)}

    before do
      grandparent.left = parent
      grandparent.right = uncle
      parent.left = node
    end

    it 'returns the grandparent' do
      expect(node.grandparent).to eq(grandparent)
    end

    it 'returns the uncle' do
      expect(node.uncle).to eq(uncle)
    end
  end
end