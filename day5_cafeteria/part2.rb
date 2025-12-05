# frozen_string_literal: true

# @param [Array<Array<Integer>>] ranges
# @return [Array<Array<Integer>>]
def merge_ranges(ranges)
  return ranges if ranges.length <= 1

  ranges = ranges.sort
  merged_ranges = [ranges[0]]
  ranges.drop(1).each do |s, t|
    if s > merged_ranges[-1][1]
      merged_ranges << [s, t]
    else
      merged_ranges[-1][1] = [merged_ranges[-1][1], t].max
    end
  end

  merged_ranges
end

input_path = ARGV.first

fresh_ranges = []

File.open(input_path, 'r') do |file|
  file.each_line.map(&:strip).each do |line|
    break if line.length.zero?
    fresh_ranges << line.split('-').map(&:to_i)
  end
end

fresh_ranges = merge_ranges(fresh_ranges)

puts fresh_ranges.map { |s, t| t - s + 1 }.sum
