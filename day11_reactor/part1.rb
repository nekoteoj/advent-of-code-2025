# frozen_string_literal: true

# @param [String] node
# @param [Hash] graph
# @param [Hash] dp
# @return [Integer]
def solve(node, graph, dp)
  return 1 if node == 'out'
  return dp[node] if dp.key?(node)

  dp[node] = graph[node].sum { |adj_node| solve(adj_node, graph, dp) }

  dp[node]
end

def main
  input_path = ARGV.first

  graph = Hash.new { |h, k| h[k] = [] }

  File.open(input_path, 'r') do |file|
    file.each_line do |line|
      node, adj_node_str = line.strip.split(':')
      graph[node] = adj_node_str.split
    end
  end

  dp = Hash.new
  puts solve('you', graph, dp)
end

main if __FILE__ == $PROGRAM_NAME
