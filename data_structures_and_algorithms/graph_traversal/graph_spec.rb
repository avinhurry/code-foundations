require_relative './graph'

RSpec.describe Graph do
  let(:graph) { Graph.new }

  describe '#breadth_first_search' do
    it 'traverses a simple 4-node tree in level order' do
      graph.add_edge(:a, :b)
      graph.add_edge(:a, :c)
      graph.add_edge(:b, :d)

      expect(graph.breadth_first_search(:a)).to eq([:a, :b, :c, :d])
    end

    it 'handles a graph with a single node' do
      expect(graph.breadth_first_search(:a)).to eq([:a])
    end

    it 'does not revisit nodes in a cycle' do
      graph.add_edge(:a, :b)
      graph.add_edge(:b, :c)
      graph.add_edge(:c, :a)  # cycle

      expect(graph.breadth_first_search(:a)).to eq([:a, :b, :c])
    end

    it 'handles disconnected nodes by only returning reachable ones' do
      graph.add_edge(:a, :b)
      graph.add_edge(:c, :d)

      expect(graph.breadth_first_search(:a)).to contain_exactly(:a, :b)
      expect(graph.breadth_first_search(:c)).to contain_exactly(:c, :d)
    end

    it 'traverses a 20-node line graph correctly' do
      nodes = (1..20).to_a

      nodes.each_cons(2) do |a, b|
        graph.add_edge(a, b)
      end

      expect(graph.breadth_first_search(1)).to eq(nodes)
    end

    it 'traverses a 20-node star graph correctly' do
      # center node connected to 1 through 19
      (2..20).each { |n| graph.add_edge(1, n) }

      result = graph.breadth_first_search(1)
      expect(result.first).to eq(1)
      expect(result.sort).to eq((1..20).to_a)
    end

    it 'traverses a 20-node balanced binary tree correctly' do
      # Simulate a binary tree
      (1..10).each do |i|
        left = i * 2
        right = i * 2 + 1
        graph.add_edge(i, left) if left <= 20
        graph.add_edge(i, right) if right <= 20
      end

      result = graph.breadth_first_search(1)
      expect(result.first).to eq(1)
      expect(result.size).to eq(20)
      expect(result).to include(20)
    end
  end

  describe '#depth_first_search' do
    it 'traverses a simple 4-node tree in depth-first order' do
      graph.add_edge(:a, :b)
      graph.add_edge(:a, :c)
      graph.add_edge(:b, :d)

      result = graph.depth_first_search(:a)

      expect(result).to include(:a, :b, :c, :d)
      expect(result.first).to eq(:a)
      expect(result.size).to eq(4)
    end

    it 'handles a graph with a single node' do
      expect(graph.depth_first_search(:a)).to eq([:a])
    end

    it 'does not revisit nodes in a cycle' do
      graph.add_edge(:a, :b)
      graph.add_edge(:b, :c)
      graph.add_edge(:c, :a)  # cycle

      result = graph.depth_first_search(:a)
      expect(result).to include(:a, :b, :c)
      expect(result.uniq.size).to eq(3)
    end

    it 'handles disconnected nodes by only returning reachable ones' do
      graph.add_edge(:a, :b)
      graph.add_edge(:c, :d)

      expect(graph.depth_first_search(:a)).to include(:a, :b)
      expect(graph.depth_first_search(:c)).to include(:c, :d)
    end

    it 'traverses a 20-node line graph correctly' do
      nodes = (1..20).to_a
      nodes.each_cons(2) { |a, b| graph.add_edge(a, b) }

      result = graph.depth_first_search(1)
      expect(result.first).to eq(1)
      expect(result.sort).to eq(nodes)
      expect(result.size).to eq(20)
    end

    it 'traverses a 20-node star graph correctly' do
      (2..20).each { |n| graph.add_edge(1, n) }

      result = graph.depth_first_search(1)
      expect(result.first).to eq(1)
      expect(result.sort).to eq((1..20).to_a)
    end

    it 'traverses a 20-node balanced binary tree correctly' do
      (1..10).each do |i|
        left = i * 2
        right = i * 2 + 1
        graph.add_edge(i, left) if left <= 20
        graph.add_edge(i, right) if right <= 20
      end

      result = graph.depth_first_search(1)
      expect(result.first).to eq(1)
      expect(result.size).to eq(20)
      expect(result).to include(20)
    end
  end
end
