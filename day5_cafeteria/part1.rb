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

# @param [Integer] ingredient
# @param [Array<Array<Integer>>] fresh_ranges
# @return [Boolean]
def ingredient_fresh?(ingredient, fresh_ranges)
  lo = 0
  hi = fresh_ranges.length - 1
  while lo < hi
    mid = (lo + hi) / 2
    if fresh_ranges[mid][1] < ingredient
      lo = mid + 1
    else
      hi = mid
    end
  end
  fresh_ranges[lo][0] <= ingredient && ingredient <= fresh_ranges[lo][1]
end

input_path = ARGV.first

fresh_ranges = []
ingredients = []

File.open(input_path, 'r') do |file|
  state = 0
  file.each_line.map(&:strip).each do |line|
    if line.length.zero?
      state = 1
      next
    end

    case state
    when 0 then fresh_ranges << line.split('-').map(&:to_i)
    else ingredients << line.to_i
    end
  end
end

fresh_ranges = merge_ranges(fresh_ranges)

puts ingredients.count { |ingredient| ingredient_fresh?(ingredient, fresh_ranges) }
