# frozen_string_literal: true

# @param [Array<Array<Integer>>] transform_matrix
# @param [Integer] m
# @param [Integer] n
# @param [Array<Integer>] y
# @return [String]
def generate_glpk_data(transform_matrix, m, n, y)
  # Define variable
  data = "param m := #{m};\n"
  data += "param n := #{n};\n\n"

  # Define transformation matrix
  data += "param A :\n"
  data += ' '
  (1..n).each do |i|
    data += ' ' * 4 + i.to_s
  end
  data += " :=\n"
  (1..m).each do |i|
    data += i.to_s
    transform_matrix[i - 1].each do |a|
      data += ' ' * 4 + a.to_s
    end
    data += "\n"
  end
  data += ";\n\n"

  # Define target y
  data += "param y :=\n"
  y.each_with_index do |x, i|
    data += "#{i + 1}#{' ' * 4}#{x}\n"
  end
  data += ";\n"
end

# @return [String]
def generate_glpk_model
  <<~MODEL
    param m;          # number of constraints (rows)
    param n;          # number of variables (columns)

    param A{i in 1..m, j in 1..n};
    param y{i in 1..m};

    var x{j in 1..n} >= 0, integer;

    minimize total_sum:
        sum{j in 1..n} x[j];

    s.t. eq_constraints{i in 1..m}:
        sum{j in 1..n} A[i,j] * x[j] = y[i];

    solve;

    printf{j in 1..n} "%d\\n", x[j] > "x.out";

    end;
  MODEL
end

def main
  if ARGV.size != 2
    puts 'Incorrect number of arguments'
    return
  end

  input_path = ARGV.first
  working_path = ARGV[1]

  model_path = File.expand_path(File.join(working_path, 'model.mod'))
  data_path = File.expand_path(File.join(working_path, 'data.dat'))

  File.open(model_path, 'w') do |file|
    file << generate_glpk_model
  end

  total_press = File.open(input_path, 'r') do |file|
    file.each_line.map(&:strip).map do |line|
      button_wiring = line
                        .scan(/\((.*?)\)/)
                        .flatten
                        .map { |w| w.split(',').map(&:to_i) }
      target_joltage = line
                         .match(/{(.*)}/)
                         &.captures
                         &.first
                         &.split(',')
                         &.map(&:to_i) || []
      wiring_masks = button_wiring.map do |wiring|
        mask = Array.new(target_joltage.length, 0)
        wiring.each { |l| mask[l] = 1 }
        mask
      end

      transform_matrix = wiring_masks.transpose
      m = target_joltage.length
      n = button_wiring.length

      File.open(data_path, 'w') do |file|
        file << generate_glpk_data(transform_matrix, m, n, target_joltage)
      end

      Dir.chdir(working_path) do
        popened_io = IO.popen("glpsol -m #{model_path} -d #{data_path}")
        Process.wait(popened_io.pid)
      end

      press = 0
      File.open(File.join(working_path, 'x.out')) do |result_file|
        press = result_file.readlines.map(&:strip).map(&:to_i).sum
      end

      press
    end
  end.sum

  puts total_press
end

main if __FILE__ == $PROGRAM_NAME

