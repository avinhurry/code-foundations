# frozen_string_literal: true

class Collection
  def initialize(numbers)
    @numbers = numbers.dup
  end

  def bubble_sort
    # This is when you look at the number to the right and check if its greater or less than the number you are on. If it's greater than you continue, if it's less then you swap it.

    is_sorted = true

    while is_sorted
      is_sorted = false

      (@numbers.size - 1).times do |i|
        if @numbers[i] > (@numbers[i + 1])
          @numbers[i], @numbers[i + 1] = @numbers[i + 1], @numbers[i]
          is_sorted = true
        end
      end
    end
    @numbers
  end

  def insertion_sort
    # This is when you look at the elements to the left and compare them, if the element to the left is greater than the element you are on, you shift it to the right. You keep doing this until the current element can be inserted in the correct position because it is greater than or = to that number.
    # This keeps happening until all the elements are in the correct order.
    # You start on the second element because there is nothing to the left of the first element.

    (1...@numbers.count).each do |i|
      key = @numbers[i]
      insertion_index = i - 1

      while insertion_index >= 0 && @numbers[insertion_index] > key

        @numbers[insertion_index + 1] = @numbers[insertion_index]
        insertion_index -= 1
      end
      @numbers[insertion_index + 1] = key
    end
    @numbers
  end

  def selection_sort
    # This works by scanning the array, searching for the smallest number and swapping it with the first unsorted number. For example [4, 2, 5]. The first unsorted number is 4 and scanning the array 2 is the smallest so 2 would be swapped with 4. This will repeat for everything in the list until everything is sorted.

    (0...@numbers.count).each do |i|
      # Start with the first element (i = 0), assume it's the smallest (min_index = i)
      min_index = i

      # Scan the rest of the list (n = i + 1 to the end) looking for a smaller number. If a smaller number is found, update the min_index to it's position.

      ((i + 1)...@numbers.count).each do |n|
        min_index = n if @numbers[n] < @numbers[min_index]
      end

      # After the scan, swap @numbers[i] with @numbers[min_index] (only if a smaller number was found). Repeat the process for the next unsorted element (i = 1, i = 2, etc.) until everything is sorted.

      @numbers[i], @numbers[min_index] = @numbers[min_index], @numbers[i] if min_index != i
    end

    # Return the sorted array
    @numbers
  end

  def merge_sort(numbers = @numbers)
    # This works by dividing the array into halves and sorting then combining the arrays back together again. This is done using recursion to (calling merge_sort inside itself) until we get to arrays with 1 or 0 elements.

    return numbers if numbers.length <= 1 # Base case: already sorted

    mid = numbers.length / 2
    left_half = merge_sort(numbers[0...mid])  # Recursively sort left half
    right_half = merge_sort(numbers[mid..])   # Recursively sort right half

    merge(left_half, right_half) # Merge the sorted halves
  end

  def merge(left, right)
    sorted_array = []

    # Compare elements and build the sorted_array
    until left.empty? || right.empty?
      sorted_array << if left.first <= right.first
                        left.shift
                      else
                        right.shift
                      end
    end

    # Add remaining elements from left or right
    sorted_array.concat(left).concat(right)
  end

  def quick_sort(numbers = @numbers)
    # This works by picking a pivot, partitioning the array into elements smaller and larger than the pivot and then recursively sorting each side.
    
    return numbers if numbers.length <= 1 # Base case: already sorted

    pivot = numbers.pop # Choose the last element as the pivot
    left = numbers.select { |num| num <= pivot } # Elements less than are equal to pivot
    right = numbers.select { |num| num > pivot } # Elements greater than pivot

    quick_sort(left) + [pivot] + quick_sort(right) # Recursively sort and combine
  end
end
