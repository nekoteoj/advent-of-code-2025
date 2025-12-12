# frozen_string_literal: true

require 'algorithms'

# @param [Array<Integer>] target_joltage
# @param [Array<Array<Integer>>] button_wiring
# @return [Integer]
def solve_astar(target_joltage, button_wiring)
  inf_dist = (1 << 63) - 1

  pq = Containers::PriorityQueue.new
  g_score = Hash.new(inf_dist) # Known distance
  f_score = Hash.new(inf_dist) # Guess with heuristic

  pq.push(target_joltage, 0)
  g_score[target_joltage] = 0
  f_score[target_joltage] = 0

  visited = Set.new

  until pq.empty?
    joltage = pq.pop
    break if joltage.all?(&:zero?)

    visited.add(joltage)

    button_wiring.each do |wiring|
      adj_joltage = joltage.dup
      wiring.each { |l| adj_joltage[l] -= 1 }
      next if adj_joltage.any?(&:negative?) || visited.include?(adj_joltage)
      adj_g_score = g_score[joltage] + 1
      if adj_g_score < g_score[adj_joltage]
        g_score[adj_joltage] = adj_g_score
        f_score[adj_joltage] = adj_g_score + adj_joltage.sum
        pq.push(adj_joltage, -f_score[adj_joltage])
      end
    end
  end

  g_score[Array.new(target_joltage.length, 0)]
end

def main
  input_path = ARGV.first

  File.open(input_path, 'r') do |file|
    file.each_line.map(&:strip).each do |line|
      button_wiring = line
                        .scan(/\((.*?)\)/)
                        .flatten
                        .map { |w| w.split(',').map(&:to_i) }
      target_joltage = line
                         .match(/{(.*)}/)
                         &.captures
                         &.first
                         &.split(',')
                         &.map(&:to_i)
      puts solve_astar(target_joltage, button_wiring)
    end
  end
end

main if __FILE__ == $PROGRAM_NAME
