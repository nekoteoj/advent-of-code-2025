# frozen_string_literal: true

input_path = ARGV.first

red_tiles = []

File.open(input_path, 'r') do |file|
  red_tiles = file
                .readlines
                .map { |line| line.chomp.split(',').map(&:to_i) }
end

n = red_tiles.length
max_area = 0
(0...n).each do |i|
  (i...n).each do |j|
    dx = (red_tiles[i][0] - red_tiles[j][0]).abs + 1
    dy = (red_tiles[i][1] - red_tiles[j][1]).abs + 1
    max_area = [max_area, dx * dy].max
  end
end

puts max_area
