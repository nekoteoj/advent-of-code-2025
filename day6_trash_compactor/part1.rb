# frozen_string_literal: true

input_path = ARGV.first

questions = []
operations = []

File.open(input_path, 'r') do |file|
  file.each_line.map(&:strip).each do |line|
    tokens = line.split
    if '+*'.include?(tokens.first)
      operations = tokens
      next
    end
    nums = tokens.map(&:to_i)
    questions = Array.new(nums.length) { [] } if questions.length.zero?
    nums.each_with_index do |num, idx|
      questions[idx] << num
    end
  end
end

answer = questions.zip(operations).map do |question, operation|
  operation == '+' ? question.sum : question.inject(:*)
end.sum

puts answer
