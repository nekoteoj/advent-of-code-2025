# frozen_string_literal: true

# @!attribute [r] count
#   @return [Integer]
#
# @!attribute [r] weight
#   @return [Integer]
#
# @api public
ConnectedComponent = Data.define(:count, :weight)

class UnionFind
  # @param [Integer] n
  def initialize(n:)
    @n = n
    @parents = (0...n).to_a
    @ranks = Array.new(n, 0)
    @counts = Array.new(n, 1)
    @weights = Array.new(n, 0)
  end

  # @param [Integer] u
  # @return [Integer]
  def find(u:)
    return u if @parents[u] == u

    @parents[u] = find(u: @parents[u])
    @parents[u]
  end

  # @param [Integer] u
  # @param [Integer] v
  # @return [Integer]
  def union(u:, v:, w:)
    u = find(u: u)
    v = find(u: v)
    return 0 if u == v

    u, v = v, u if @ranks[u] < @ranks[v]
    @parents[v] = u
    @ranks[u] += 1
    @counts[u] += @counts[v]
    @weights[u] += @weights[v] + w
    1
  end

  # @return [Array<ConnectedComponent>]
  def build_component
    (0...@n)
      .filter { |i| @parents[i] == i }
      .map { |i| ConnectedComponent.new(count: @counts[i], weight: @weights[i]) }
  end
end
