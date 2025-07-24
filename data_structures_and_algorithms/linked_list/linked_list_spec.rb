require_relative '../linked_list/linked_list'

RSpec.describe LinkedList do
  let(:list) { LinkedList.new }

  describe '#insert' do
    it 'inserts the first node as head' do
      list.insert(10)
      expect(list.head.value).to eq(10)
    end

    it 'inserts multiple nodes to the end of the list' do
      list.insert(1)
      list.insert(2)
      list.insert(3)

      expect(list.head.value).to eq(1)
      expect(list.head.next_node.value).to eq(2)
      expect(list.head.next_node.next_node.value).to eq(3)
    end
  end

  describe '#search' do
    before do
      list.insert(5)
      list.insert(10)
      list.insert(15)
    end

    it 'returns true if the value exists in the list' do
      expect(list.search(10)).to be true
    end

    it 'returns false if the value does not exist in the list' do
      expect(list.search(42)).to be false
    end
  end

  describe '#delete' do
    before do
      list.insert(1)
      list.insert(2)
      list.insert(3)
    end

    it 'deletes the head node if it matches the value' do
      list.delete(1)
      expect(list.head.value).to eq(2)
    end

    it 'deletes a node from the middle of the list' do
      list.delete(2)
      expect(list.head.next_node.value).to eq(3)
    end

    it 'deletes the last node' do
      list.delete(3)
      expect(list.head.next_node.next_node).to be_nil
    end

    it 'does nothing if the value is not found' do
      expect { list.delete(99) }.not_to raise_error
      expect(list.head.value).to eq(1)
      expect(list.head.next_node.value).to eq(2)
      expect(list.head.next_node.next_node.value).to eq(3)
    end
  end
end
