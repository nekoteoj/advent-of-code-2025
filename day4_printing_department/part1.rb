# frozen_string_literal: true

input_path = ARGV.first

grids = []

File.open(input_path, 'r') do |file|
  grids = file.readlines.map(&:strip).map(&:chars)
end

n = grids.length
m = grids[0].length

total_paper = 0

(0...n).each do |i|
  (0...m).each do |j|
    adj_papers = 0
    (-1..1).each do |di|
      (-1..1).each do |dj|
        next if di.zero? && dj.zero?
        adj_i = i + di
        adj_j = j + dj
        next if adj_i < 0 || adj_i >= n || adj_j < 0 || adj_j >= m
        adj_papers += 1 if grids[adj_i][adj_j] == '@'
      end
    end
    total_paper += 1 if grids[i][j] == '@' && adj_papers < 4
  end
end

puts total_paper
