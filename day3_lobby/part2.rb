# frozen_string_literal: true

input_path = ARGV.first

total_joltage = 0

File.open(input_path, 'r') do |file|
  total_joltage = file.each_line.map(&:strip).map do |line|
    batteries = line.each_char.map(&:to_i)
    start = 0
    (0...12).map do |i|
      best_battery_idx = start
      batteries[start..(i - 12)].each_with_index do |battery, j|
        best_battery_idx = start + j if battery > batteries[best_battery_idx]
      end
      start = best_battery_idx + 1
      batteries[best_battery_idx]
    end.inject(0) { |acc, x| acc * 10 + x }
  end.sum
end

puts total_joltage
