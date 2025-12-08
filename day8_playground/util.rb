# frozen_string_literal: true

# @param [Array<Integer>] point1
# @param [Array<Integer>] point2
# @return [Integer]
def square_euclidean_distance(point1, point2)
  point1.zip(point2).map { |p1, p2| (p1 - p2) ** 2 }.sum
end
