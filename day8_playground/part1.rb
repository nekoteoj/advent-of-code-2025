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
(0...[1000, edges.size].min).each do |i|
  u, v, w = edges[i]
  union_find.union(u: u, v: v, w: w)
end

components = union_find.build_component
components.sort_by!(&:count).reverse!

puts components.take(3).map(&:count).inject(:*)
