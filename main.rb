# frozen_string_literal: true

# all logic will be in this class
class KnightMoves
  attr_accessor :board, :graph

  MOVES = [[1, 2], [2, 1], [2, -1], [1, -2],
           [-1, -2], [-2, -1], [-2, 1], [-1, 2]].freeze
  def initialize
    @board = (1..8).to_a.repeated_permutation(2).to_a
    @graph = []
    build_graph
  end
  
  def build_graph(board = @board)
    board.each do |value|
      cell = Cell.new(value)
      cell.children = add_children(cell.place)
      @graph << cell
    end
  end

  def add_children(place)
    # adds possibles moves as children for each cell on board
    children = []
    MOVES.each do |move|
      move.each do |m|
      children.push([move, place].transpose.map{|x|x.reduce(:+)})
      end
    end
    # deletes any out of borders moves
    children.uniq!.delete_if{ |child| child.any? {|coordinate| coordinate < 1 || coordinate > 8 }}
    children
  end
end

class Cell 
  attr_accessor :place, :children
  def initialize(place = [1, 1], children = [])
    @place = place
    @children = children
  end
end

p game = KnightMoves.new


