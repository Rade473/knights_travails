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

  def knight_moves(start, finish, queue = [])
    current_cell = find_cell(start)
    current_cell.visited = true

    return current_cell if current_cell.place == finish

    current_cell.children.each do |child|
      queue.push(child)
    end

    until queue.empty?
      current_cell = find_cell(queue.shift)
      if current_cell.place == finish
        queue.clear
        trace_path(start,finish)
        return current_cell
      end
      current_cell.visited = true
      current_cell.children.each do |child|
        if !find_cell(child).visited
          queue.push(child)
          find_cell(child).parent = current_cell.place
    
        
        end
      end
    end
  end

  def trace_path(start,finish)
    path = []
    node = find_cell(finish)
    while !node.parent.empty?
      path.push(node.parent)
      node = find_cell(node.parent)
    end
    puts "To get from #{start} to #{finish}"
    path.reverse.unshift(start).push(finish).each do |step|
    puts "Move to #{step}"
    end
  end

  def find_cell(place, cell = graph)
    cell.each do |spot|
      if spot.place == place
        return spot
      end
    end
  end
end


class Cell 
  attr_accessor :place, :children, :parent, :visited
  def initialize(place = [1, 1], children = [], parent = [], visited = false)
    @place = place
    @children = children
    @parent = parent
    @visited = visited
  end
end

game = KnightMoves.new

game.knight_moves([1,1],[8,8])
