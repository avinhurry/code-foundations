# frozen_string_literal: true

require 'prime'
class TableGenerator
  attr_accessor :x_axis, :y_axis

  def initialize(operation:, x_axis: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], y_axis: Prime.take(10))
    @operation = operation
    @x_axis = x_axis
    @y_axis = y_axis
  end

  def formatted_table
    append_zero

    formatted_x_axis

    formatted_values_based_on_operation
  end

  private

  def formatted_values_based_on_operation
    case @operation
    when 'multiplication'
      arrays_of_values_multiplied.each do |row|
        puts row.join
      end
    when 'addition'
      arrays_of_values_added.each do |row|
        puts row.join
      end
    when 'subtraction'
      arrays_of_values_subtracted.each do |row|
        puts row.join
      end
    when 'division'
      arrays_of_values_divided.each do |row|
        puts row.join
      end
    end
  end

  def arrays_of_values_multiplied
    y_axis.map do |y|
      result_row = x_axis.map do |x|
        (x * y).to_s.ljust(5)
      end
      [y.to_s.ljust(5)] + result_row
    end
  end

  def arrays_of_values_added
    y_axis.map do |y|
      result_row = x_axis.map do |x|
        (x + y).to_s.ljust(5)
      end
      [y.to_s.ljust(5)] + result_row
    end
  end

  def arrays_of_values_subtracted
    y_axis.map do |y|
      result_row = x_axis.map do |x|
        (x - y).to_s.ljust(5)
      end
      [y.to_s.ljust(5)] + result_row
    end
  end

  def arrays_of_values_divided
    y_axis.map do |y|
      result_row = x_axis.map do |x|
        (x / y).to_s.ljust(5)
      end
      [y.to_s.ljust(5)] + result_row
    end
  end

  def formatted_x_axis
    x_axis.each { |x| print x.to_s.ljust(5) }
    puts  '', '__'.ljust(5) * (x_axis.count + 1)
  end

  def append_zero
    print '0    '
  end
end
