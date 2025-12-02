# frozen_string_literal: true

input_path = ARGV.first

position = 50
bound = 100
password = 0

File.open(input_path, 'r') do |file|
  file.each_line.map(&:strip).each do |line|
    sign = line[0] == 'L' ? -1 : 1
    amount = line[1..].to_i
    adjusted_position = amount + case sign
                                 when 1 then position
                                 else ((bound - position) % bound)
                                 end
    password += (adjusted_position / bound).abs
    position += sign * amount
    position = ((position % bound) + bound) % bound
  end
end

puts password
