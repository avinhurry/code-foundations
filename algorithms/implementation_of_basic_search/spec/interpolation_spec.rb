require_relative '../app/interpolation_search'

RSpec.describe InterpolationSearch do
  context 'with a normal sorted array' do
    let(:array) { [10, 20, 30, 40, 50, 60, 70] }
    let(:interpolation_search) { InterpolationSearch.new(array) }

    it 'finds an existing element' do
      expect(interpolation_search.search(40)).to eq(3)
    end

    it 'returns nil for a non-existing element' do
      expect(interpolation_search.search(8)).to be_nil
    end

    it 'finds the first element' do
      expect(interpolation_search.search(10)).to eq(0)
    end

    it 'finds the last element' do
      expect(interpolation_search.search(70)).to eq(6)
    end

    it 'returns nil if the target is smaller than the smallest element' do
      expect(interpolation_search.search(5)).to be_nil
    end

    it 'returns nil if the target is larger than the largest element' do
      expect(interpolation_search.search(80)).to be_nil
    end
  end

  context 'with an empty array' do
    let(:empty_search) { InterpolationSearch.new([]) }

    it 'returns nil for any search' do
      expect(empty_search.search(40)).to be_nil
    end
  end

  context 'with a single-element array' do
    let(:single_element_search) { InterpolationSearch.new([50]) }

    it 'finds the only element' do
      expect(single_element_search.search(50)).to eq(0)
    end

    it 'returns nil for an element not in the array' do
      expect(single_element_search.search(10)).to be_nil
    end
  end

  context 'with duplicates in the array' do
    let(:array) { [10, 20, 20, 20, 30, 40, 50] }
    let(:interpolation_search) { InterpolationSearch.new(array) }
  
    it 'finds the first occurrence of a duplicate value' do
      expect(interpolation_search.search(20)).to eq(1) 
    end
  end
end
