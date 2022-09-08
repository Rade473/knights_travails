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

  # Builds a board with each spot assigned all it's possible children
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
    children.uniq!.delete_if { |child| child.any? {|coordinate| coordinate < 1 || coordinate > 8 }}
    children
  end

  def knight_moves(start, finish, queue = [])
    current_cell = find_cell(start)
    current_cell.visited = true
    # Visit first cell and check for destination
    return current_cell if current_cell.place == finish

    # Queue all childdren from first node
    current_cell.children.each do |child|
      queue.push(child)
    end

    until queue.empty?
      # Take first child from queue
      current_cell = find_cell(queue.shift)
      # Guard clause
      if current_cell.place == finish
        queue.clear
        trace_path(start,finish)
        return current_cell
      end
      # Mark visited the cell and enqueue all its children, 
      # unless they have already been visited
      current_cell.visited = true
      current_cell.children.each do |child|
        if !find_cell(child).visited
          queue.push(child)
          # Set the parent node to the current one to keep track
          find_cell(child).parent = current_cell.place
        end
      end
    end
  end

  # Takes the finish and usingg reverse tracking through nodes @parent
  # instance, creates an array with visited nodes that brought us there
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

  # This is a helper method to connect a node to a place like [1,1]
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

game.knight_moves([1, 1],[8, 8])
