# frozen_string_literal: true

input_path = ARGV.first

position = 50
bound = 100
password = 0

File.open(input_path, 'r') do |file|
  file.each_line.map(&:strip).each do |line|
    sign = line[0] == 'L' ? -1 : 1
    amount = line[1..].to_i
    position = (((position + sign * amount) % bound) + bound) % bound
    password += 1 if position.zero?
  end
end

puts password
