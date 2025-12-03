# frozen_string_literal: true

input_path = ARGV.first

primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
ranges = []

File.open(input_path, 'r') do |file|
  ranges = file.readline
               .strip
               .split(',')
               .map { |s| s.split('-').map(&:to_i) }
end

invalid_sum = 0
ranges.each do |s, t|
  (s..t).each do |id|
    id_str = id.to_s
    any_invalid = primes.map do |prime|
      next if prime > id_str.length
      next unless (id_str.length % prime).zero?
      window = id_str.length / prime
      invalid = true
      (0...(id_str.length - window)).step(window).each do |idx|
        if id_str[idx...(idx + window)] != id_str[(idx + window)...(idx + 2 * window)]
          invalid = false
          break
        end
      end
      invalid
    end.any?
    invalid_sum += id if any_invalid
  end
end

puts invalid_sum
