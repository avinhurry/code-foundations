require 'pry'

class InterpolationSearch
  def initialize(array)
    @array = array
  end

  def search(target)
    low = 0
    high = @array.length - 1

    while low <= high && target >= @array[low] && target <= @array[high]
      return low if @array[low] == target

      pos = low + ((target - @array[low]) * (high - low) / (@array[high] - @array[low]))

      return nil if pos < low || pos > high

      if @array[pos] == target
        return pos
      elsif @array[pos] < target
        low = pos + 1
      else
        high = pos - 1
      end
    end
    nil
  end
end