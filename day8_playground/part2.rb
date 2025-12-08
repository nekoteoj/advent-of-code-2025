# frozen_string_literal: true

require_relative 'util'
require_relative 'union_find'

input_path = ARGV.first

points = []
edges = []

File.open(input_path, 'r') do |file|
  points = file
             .readlines
             .map { |l| l.chomp.split(',').map(&:to_i) }
end

n = points.size
(0...n).each do |i|
  ((i + 1)...n).each do |j|
    w = square_euclidean_distance(points[i], points[j])
    edges << [i, j, w]
  end
end

edges.sort_by!(&:last)

union_find = UnionFind.new(n: n)
last_edge = edges[-1]
edges.each do |edge|
  u, v, w = edge
  union_find.union(u: u, v: v, w: w)
  if union_find.component_count == 1
    last_edge = edge
    break
  end
end

puts points[last_edge[0]][0] * points[last_edge[1]][0]
