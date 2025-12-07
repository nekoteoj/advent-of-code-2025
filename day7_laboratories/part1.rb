# frozen_string_literal: true

input_path = ARGV.first

graph = []

File.open(input_path, 'r') do |file|
  graph = file.readlines.map(&:strip).map(&:chars)
end

queue = Thread::Queue.new
start_col = graph[0].index('S')
queue << [0, start_col]

split_count = 0

until queue.empty?
  i, j = queue.pop
  next if i + 1 >= graph.length
  if graph[i + 1][j] == '.'
    graph[i + 1][j] = '|'
    queue << [i + 1, j]
  elsif graph[i + 1][j] == '^'
    split_count += 1
    [j - 1, j + 1].each do |adj_j|
      next if adj_j >= graph[0].length or adj_j < 0
      next if graph[i + 1][adj_j] == '|'
      graph[i + 1][adj_j] = '|'
      queue << [i + 1, adj_j]
    end
  end
end

puts split_count
