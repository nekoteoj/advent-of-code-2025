# frozen_string_literal: true

input_path = ARGV.first

graph = []

File.open(input_path, 'r') do |file|
  graph = file.readlines.map(&:strip).map(&:chars)
end

n = graph[0].length
m = graph[1].length

dp = Array.new(m, 0)
dp_new = Array.new(m, 0)
dp[graph[0].index('S')] = 1

(1...n).each do |i|
  (0...m).each do |j|
    next if graph[i][j] == '^'
    dp_new[j] += dp[j]
    dp_new[j] += dp[j - 1] if j > 0 && graph[i][j - 1] == '^'
    dp_new[j] += dp[j + 1] if j + 1 < m && graph[i][j + 1] == '^'
  end
  dp, dp_new = dp_new, dp
  (0...m).each { |j| dp_new[j] = 0 }
end

puts dp.sum
