# frozen_string_literal: true

input_path = ARGV.first

text = []

File.open(input_path, 'r') do |file|
  text = file.readlines.map(&:chomp).map(&:chars)
  column_width = (text.max_by(&:length) || '').length
  text.each do |line|
    line << " " while line.length < column_width
  end
end

answer = 0

col_idx = text.first.length - 1
question = []
num = 0
while col_idx >= 0
  (0...(text.length - 1)).each do |row_idx|
    next if text[row_idx][col_idx].strip.empty?
    digit = text[row_idx][col_idx].to_i
    num = num * 10 + digit
  end
  question << num
  num = 0
  if '+*'.include?(text[-1][col_idx])
    answer += text[-1][col_idx] == '+' ? question.sum : question.inject(:*)
    question = []
    col_idx -= 1
  end
  col_idx -= 1
end

puts answer
