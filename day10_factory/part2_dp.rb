# frozen_string_literal: true

# @param [Array<Integer>] joltage
# @param [Array<Array<Integer>>] button_wiring
# @param [Hash] dp
# @return [Integer]
def solve_dp(joltage, button_wiring, dp)
  return 0 if joltage.all?(&:zero?)
  return dp[joltage] if dp.key?(joltage)

  min_cost = (1 << 63) - 1
  button_wiring.each do |wiring|
    new_joltage = joltage.dup
    wiring.each { |l| new_joltage[l] -= 1 }
    next if new_joltage.any?(&:negative?)
    min_cost = [min_cost, 1 + solve_dp(new_joltage, button_wiring, dp)].min
  end

  dp[joltage] = min_cost
  min_cost
end

def main
  input_path = ARGV.first

  total_cost = File.open(input_path, 'r') do |file|
    file.each_line.map(&:strip).map do |line|
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
      dp = Hash.new
      min_cost = solve_dp(target_joltage, button_wiring, dp)
      print("Answer: #{solve_dp(target_joltage, button_wiring, dp)}\n")
      min_cost
    end.sum
  end

  puts total_cost
end

main if __FILE__ == $PROGRAM_NAME
