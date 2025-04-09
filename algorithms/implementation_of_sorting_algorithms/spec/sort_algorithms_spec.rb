# frozen_string_literal: true
require 'pry'

require_relative '../app/sort_algorithms'

RSpec.describe Collection do
  let(:collection) { described_class.new(numbers) }
  let(:numbers) { [2, 9, 1, 2, 29, 1] }
  let(:ordered_numbers) { [1, 1, 2, 2, 9, 29] }

  describe '#bubble_sort' do
    context 'with a random list of numbers' do
      it 'sorts the numbers in the correct order' do
        expect(collection.bubble_sort).to eq(ordered_numbers)
      end
    end

    context 'with a reversed list of numbers (slowest for bubble sort)' do
      let(:numbers) { [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0] }
      let(:ordered_numbers) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
      it 'sorts the numbers in the correct order' do
        expect(collection.bubble_sort).to eq(ordered_numbers)
      end
    end
  end

  describe '#insertion_sort' do
    context 'with a random list of numbers' do
      it 'sorts the numbers in the correct order' do
        expect(collection.insertion_sort).to eq(ordered_numbers)
      end
    end

    context 'with a reversed list of numbers' do
      let(:numbers) { [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0] }
      let(:ordered_numbers) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
      it 'sorts the numbers in the correct order' do
        expect(collection.insertion_sort).to eq(ordered_numbers)
      end
    end
  end

  describe '#selection_sort' do
    context 'with a random list of numbers' do
      it 'sorts the numbers in the correct order' do
        expect(collection.selection_sort).to eq(ordered_numbers)
      end
    end

    context 'with a reversed list of numbers' do
      let(:numbers) { [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0] }
      let(:ordered_numbers) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
      it 'sorts the numbers in the correct order' do
        expect(collection.selection_sort).to eq(ordered_numbers)
      end
    end

    describe '#merge_sort' do
      context 'with a random list of numbers' do
        it 'sorts the numbers in the correct order' do
          expect(collection.merge_sort).to eq(ordered_numbers)
        end
      end

      context 'with a reversed list of numbers' do
        let(:numbers) { [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0] }
        let(:ordered_numbers) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
        it 'sorts the numbers in the correct order' do
          expect(collection.merge_sort).to eq(ordered_numbers)
        end
      end
    end

    describe '#quick_sort' do
      context 'with a random list of numbers' do
        it 'sorts the numbers in the correct order' do
          expect(collection.quick_sort).to eq(ordered_numbers)
        end
      end

      context 'with a reversed list of numbers' do
        let(:numbers) { [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0] }
        let(:ordered_numbers) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
        it 'sorts the numbers in the correct order' do
          expect(collection.quick_sort).to eq(ordered_numbers)
        end
      end
    end
  end
end
