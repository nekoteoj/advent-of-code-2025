# frozen_string_literal: true

# @param [String] light
# @return [Integer]
def light_to_state(light)
  state = 0
  light.reverse.each_char do |l|
    state = (state << 1) + (l == '#' ? 1 : 0)
  end
  state
end

# @param [Array<Integer>] button_wiring
# @return [Integer]
def button_wiring_to_edge(button_wiring)
  edge = 0
  button_wiring.each do |l|
    edge ^= (1 << l)
  end
  edge
end
