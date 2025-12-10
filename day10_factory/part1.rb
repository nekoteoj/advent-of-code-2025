# frozen_string_literal: true

require_relative 'shared'

# @param [Integer] initial_state
# @param [Integer] target_state
# @param [Integer] max_state
# @param [Array<Integer>] edges
# @return [Integer]
def solve_bfs(initial_state, target_state, max_state, edges)
  queue = Thread::Queue.new
  inf_dist = (1 << 63) - 1
  dist = Array.new(max_state + 1, inf_dist)

  queue << initial_state
  dist[initial_state] = 0

  until queue.empty?
    state = queue.pop
    break if state == target_state
    edges.each do |edge|
      next_state = state ^ edge
      if dist[next_state] == inf_dist
        dist[next_state] = dist[state] + 1
        queue << next_state
      end
    end
  end

  dist[target_state]
end

def main
  input_path = ARGV.first

  total_press = File.open(input_path, 'r') do |file|
    file.each_line.map(&:strip).map do |line|
      target_light = line.match(/\[(.*?)\]/)&.captures&.first || ''
      button_wiring = line
                        .scan(/\((.*?)\)/)
                        .flatten
                        .map { |w| w.split(',').map(&:to_i) }

      target_state = light_to_state(target_light)
      max_state = (1 << target_light.length) - 1
      edges = button_wiring.map { |wiring| button_wiring_to_edge(wiring) }

      solve_bfs(0, target_state, max_state, edges)
    end.sum
  end

  puts total_press
end

main if __FILE__ == $PROGRAM_NAME
