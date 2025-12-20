# frozen_string_literal: true

# @param [String] node
# @param [String] target
# @param [Hash] graph
# @param [Hash] dp
# @return [Integer]
def solve(node, target, graph, dp)
  return 1 if node == target
  return dp[node] if dp.key?(node)

  dp[node] = graph[node].sum { |adj_node| solve(adj_node, target, graph, dp) }

  dp[node]
end

def main
  input_path = ARGV.first

  graph = Hash.new { |h, k| h[k] = [] }
  graph_wo_dac = Hash.new { |h, k| h[k] = [] }

  File.open(input_path, 'r') do |file|
    file.each_line do |line|
      node, adj_node_str = line.strip.split(':')
      graph[node] = adj_node_str.split
      next if node == 'dac'
      graph_wo_dac[node] = graph[node].reject { |adj_node| adj_node == 'dac' }
    end
  end

  svr_to_fft = solve('svr', 'fft', graph, Hash.new)
  fft_to_out = solve('fft', 'out', graph, Hash.new)
  svr_to_fft_wo_dac = solve('svr', 'fft', graph_wo_dac, Hash.new)
  fft_to_out_wo_dac = solve('fft', 'out', graph_wo_dac, Hash.new)
  puts svr_to_fft * fft_to_out - svr_to_fft_wo_dac * fft_to_out_wo_dac
end

main if __FILE__ == $PROGRAM_NAME
