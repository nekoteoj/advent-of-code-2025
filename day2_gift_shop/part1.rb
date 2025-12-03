# frozen_string_literal: true

input_path = ARGV.first

ranges = []

File.open(input_path, 'r') do |file|
  ranges = file.readline
               .strip
               .split(',')
               .map { |s| s.split('-').map(&:to_i) }
end

invalid_sum = 0
ranges.each do |s, t|
  (s..t).each do |id|
    id_str = id.to_s
    next if id_str.length.odd?
    mid = id_str.length >> 1
    invalid_sum += id if id_str[...mid] == id_str[mid..]
  end
end

puts invalid_sum
