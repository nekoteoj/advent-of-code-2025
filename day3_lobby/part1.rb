# frozen_string_literal: true

input_path = ARGV.first

total_joltage = 0

File.open(input_path, 'r') do |file|
  total_joltage = file.each_line.map(&:strip).map do |line|
    max_joltage = 0
    high = line[0].to_i
    line.each_char.drop(1).map(&:to_i).each do |x|
      joltage = high * 10 + x
      max_joltage = joltage if joltage > max_joltage
      high = x if x > high
    end
    max_joltage
  end.sum
end

puts total_joltage
