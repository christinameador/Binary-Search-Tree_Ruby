# frozen_string_literal: true
#require 'pry'; binding.pry #rubocop:disable all

# node within a binary search tree
class Node
  include Comparable
  attr_accessor :data, :left_child, :right_child

  def initialize(data)
    @data = data
    @left_child = nil
    @right_child = nil
  end

  # def <=>(other)
  #   @data <=> other.data
  # end
end
