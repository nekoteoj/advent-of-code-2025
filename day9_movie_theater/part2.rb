# frozen_string_literal: true

input_path = ARGV.first

red_tiles = []

File.open(input_path, 'r') do |file|
  red_tiles = file
                .readlines
                .map { |line| line.chomp.split(',').map(&:to_i) }
end

# Compress coordinate

original_red_tiles = red_tiles.map(&:dup)
x_axis_map = red_tiles.map(&:first).to_set.sort.each_with_index.to_h
y_axis_map = red_tiles.map(&:last).to_set.sort.each_with_index.to_h
red_tiles = red_tiles.map { |x, y| [x_axis_map[x] + 1, y_axis_map[y] + 1] }

# Create grid and assign boundary

n_row = red_tiles.max_by(&:first)[0] + 2
n_col = red_tiles.max_by(&:last)[1] + 2

grids = Array.new(n_row) { Array.new(n_col, 0) }
red_tiles.each_with_index do |red_tile, i|
  adj_red_tile = red_tiles[(i + 1) % red_tiles.length]
  dx = red_tile[0] - adj_red_tile[0]
  dy = red_tile[1] - adj_red_tile[1]
  dx /= dx.abs unless dx.zero?
  dy /= dy.abs unless dy.zero?
  x = adj_red_tile[0]
  y = adj_red_tile[1]
  until x == red_tile[0] && y == red_tile[1]
    grids[x][y] = 1
    x += dx
    y += dy
  end
  grids[red_tile[0]][red_tile[1]] = 1
end

# Find outside polygon area

visited = Array.new(n_row) { Array.new(n_col, false) }
queue = Thread::Queue.new
queue << [0, 0] # Outside polygon point
visited[0][0] = true
until queue.empty?
  x, y = queue.pop
  [[-1, 0], [0, 1], [1, 0], [0, -1]].each do |dx, dy|
    adj_x = x + dx
    adj_y = y + dy
    next if adj_x < 0 || adj_x >= n_row || adj_y < 0 || adj_y >= n_col
    next if visited[adj_x][adj_y]
    next if grids[adj_x][adj_y] == 1
    visited[adj_x][adj_y] = true
    queue << [adj_x, adj_y]
  end
end

# Paint inside area of polygon

(0...n_row).each do |i|
  (0...n_col).each do |j|
    grids[i][j] = 1 unless visited[i][j]
  end
end

# 2D Quick Sum Preprocessing

dp = Array.new(n_row) { Array.new(n_col, 0) }
(1...n_row).each { |i| dp[i][0] = grids[i][0] + dp[i - 1][0] }
(1...n_col).each { |i| dp[0][i] = grids[0][i] + dp[0][i - 1] }
(1...n_row).each do |i|
  (1...n_col).each do |j|
    dp[i][j] = grids[i][j] + dp[i - 1][j] + dp[i][j - 1] - dp[i - 1][j - 1]
  end
end

# Enumerate red pile pairs and compute answer

max_area = 0

(0...red_tiles.length).each do |i|
  (0...red_tiles.length).each do |j|
    x1 = [red_tiles[i][0], red_tiles[j][0]].min
    x2 = [red_tiles[i][0], red_tiles[j][0]].max
    y1 = [red_tiles[i][1], red_tiles[j][1]].min
    y2 = [red_tiles[i][1], red_tiles[j][1]].max
    area = (x2 - x1 + 1) * (y2 - y1 + 1)
    grid_sum = dp[x2][y2] - dp[x1 - 1][y2] - dp[x2][y1 - 1] + dp[x1 - 1][y1 - 1]
    if area == grid_sum
      original_red_tile_1 = original_red_tiles[i]
      original_red_tile_2 = original_red_tiles[j]
      original_x1 = [original_red_tile_1[0], original_red_tile_2[0]].min
      original_x2 = [original_red_tile_1[0], original_red_tile_2[0]].max
      original_y1 = [original_red_tile_1[1], original_red_tile_2[1]].min
      original_y2 = [original_red_tile_1[1], original_red_tile_2[1]].max
      original_area = (original_x2 - original_x1 + 1) * (original_y2 - original_y1 + 1)
      max_area = [max_area, original_area].max
    end
  end
end

puts max_area
