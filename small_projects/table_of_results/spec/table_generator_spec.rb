# frozen_string_literal: true

require_relative '../app/table_generator'
require 'pry'

RSpec.describe TableGenerator do
  describe '#formatted_table_body' do
    context 'when multiplying' do
      it 'includes the correct numbers' do
        table_generator = described_class.new(operation: 'multiplication')

        expected_output = <<~TABLE
          0    1    2    3    4    5    6    7    8    9    10#{'   '}
          __   __   __   __   __   __   __   __   __   __   __#{'   '}
          2    2    4    6    8    10   12   14   16   18   20#{'   '}
          3    3    6    9    12   15   18   21   24   27   30#{'   '}
          5    5    10   15   20   25   30   35   40   45   50#{'   '}
          7    7    14   21   28   35   42   49   56   63   70#{'   '}
          11   11   22   33   44   55   66   77   88   99   110#{'  '}
          13   13   26   39   52   65   78   91   104  117  130#{'  '}
          17   17   34   51   68   85   102  119  136  153  170#{'  '}
          19   19   38   57   76   95   114  133  152  171  190#{'  '}
          23   23   46   69   92   115  138  161  184  207  230#{'  '}
          29   29   58   87   116  145  174  203  232  261  290#{'  '}
        TABLE
        expect { table_generator.formatted_table }.to output(expected_output).to_stdout
      end
    end

    context 'when adding' do
      it 'includes the correct numbers' do
        table_generator = described_class.new(operation: 'addition')

        expected_output = <<~TABLE
          0    1    2    3    4    5    6    7    8    9    10#{'   '}
          __   __   __   __   __   __   __   __   __   __   __#{'   '}
          2    3    4    5    6    7    8    9    10   11   12#{'   '}
          3    4    5    6    7    8    9    10   11   12   13#{'   '}
          5    6    7    8    9    10   11   12   13   14   15#{'   '}
          7    8    9    10   11   12   13   14   15   16   17#{'   '}
          11   12   13   14   15   16   17   18   19   20   21#{'   '}
          13   14   15   16   17   18   19   20   21   22   23#{'   '}
          17   18   19   20   21   22   23   24   25   26   27#{'   '}
          19   20   21   22   23   24   25   26   27   28   29#{'   '}
          23   24   25   26   27   28   29   30   31   32   33#{'   '}
          29   30   31   32   33   34   35   36   37   38   39#{'   '}
        TABLE
        expect { table_generator.formatted_table }.to output(expected_output).to_stdout
      end
    end

    context 'when subtracting' do
      it 'includes the correct numbers' do
        table_generator = described_class.new(operation: 'subtraction')

        expected_output = <<~TABLE
          0    1    2    3    4    5    6    7    8    9    10#{'   '}
          __   __   __   __   __   __   __   __   __   __   __#{'   '}
          2    -1   0    1    2    3    4    5    6    7    8#{'    '}
          3    -2   -1   0    1    2    3    4    5    6    7#{'    '}
          5    -4   -3   -2   -1   0    1    2    3    4    5#{'    '}
          7    -6   -5   -4   -3   -2   -1   0    1    2    3#{'    '}
          11   -10  -9   -8   -7   -6   -5   -4   -3   -2   -1#{'   '}
          13   -12  -11  -10  -9   -8   -7   -6   -5   -4   -3#{'   '}
          17   -16  -15  -14  -13  -12  -11  -10  -9   -8   -7#{'   '}
          19   -18  -17  -16  -15  -14  -13  -12  -11  -10  -9#{'   '}
          23   -22  -21  -20  -19  -18  -17  -16  -15  -14  -13#{'  '}
          29   -28  -27  -26  -25  -24  -23  -22  -21  -20  -19#{'  '}
        TABLE
        expect { table_generator.formatted_table }.to output(expected_output).to_stdout
      end
    end

    context 'when dividing' do
      it 'includes the correct numbers' do
        table_generator = described_class.new(operation: 'division')

        expected_output = <<~TABLE
          0    1    2    3    4    5    6    7    8    9    10#{'   '}
          __   __   __   __   __   __   __   __   __   __   __#{'   '}
          2    0    1    1    2    2    3    3    4    4    5#{'    '}
          3    0    0    1    1    1    2    2    2    3    3#{'    '}
          5    0    0    0    0    1    1    1    1    1    2#{'    '}
          7    0    0    0    0    0    0    1    1    1    1#{'    '}
          11   0    0    0    0    0    0    0    0    0    0#{'    '}
          13   0    0    0    0    0    0    0    0    0    0#{'    '}
          17   0    0    0    0    0    0    0    0    0    0#{'    '}
          19   0    0    0    0    0    0    0    0    0    0#{'    '}
          23   0    0    0    0    0    0    0    0    0    0#{'    '}
          29   0    0    0    0    0    0    0    0    0    0#{'    '}
        TABLE
        expect { table_generator.formatted_table }.to output(expected_output).to_stdout
      end
    end
  end
end
