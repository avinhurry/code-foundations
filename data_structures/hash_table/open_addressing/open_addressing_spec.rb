require 'rspec'
require_relative 'open_addressing'

RSpec.describe OpenAddressing do
  let(:hash_table) { OpenAddressing.new }

  describe '#set and #get' do
    it 'stores and retrieves a value by key' do
      hash_table.set('foo', 'bar')
      expect(hash_table.get('foo')).to eq('bar')
    end

    it 'overwrites the value if the key already exists' do
      hash_table.set('foo', 'bar')
      hash_table.set('foo', 'baz')
      expect(hash_table.get('foo')).to eq('baz')
    end

    it 'returns nil for a key that does not exist' do
      expect(hash_table.get('missing')).to be_nil
    end

    it 'handles empty string keys' do
      hash_table.set('', 'empty')
      expect(hash_table.get('')).to eq('empty')
      expect(hash_table.delete('')).to eq('empty')
      expect(hash_table.get('')).to be_nil
    end
  end

  describe '#delete' do
    it 'removes a key and returns its value' do
      hash_table.set('foo', 'bar')
      expect(hash_table.delete('foo')).to eq('bar')
      expect(hash_table.get('foo')).to be_nil
    end

    it 'returns nil when deleting a non existent key' do
      expect(hash_table.delete('ghost')).to be_nil
    end
  end

  describe 'collision handling (chaining)' do
    it 'handles multiple keys with the same hash index' do
      allow_any_instance_of(String).to receive(:hash).and_return(0)
      hash_table.set('a', 1)
      hash_table.set('b', 2)

      expect(hash_table.get('a')).to eq(1)
      expect(hash_table.get('b')).to eq(2)

      hash_table.delete('a')
      expect(hash_table.get('a')).to be_nil
      expect(hash_table.get('b')).to eq(2)
    end
  end
  describe 'scale and performance' do
  # Setting the size to 2000 because there is no automatic resizing, so the hash table is full with the default size of 16.
  let(:hash_table) { OpenAddressing.new(2000) }
    it 'handles a large number of keys without error' do
      1_000.times { |i| hash_table.set("key#{i}", i) }
      expect(hash_table.get('key998')).to eq(998)
    end
  end
end
