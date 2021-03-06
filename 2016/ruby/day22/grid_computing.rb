require 'minitest/autorun'
require 'set'
require 'pry'

class Node
  NODE_DESCR = /\/dev\/grid\/node-x(?<x>\d+)-y(?<y>\d+)(?: +)(?<size>\d+)T(?: +)(?: +)(?<used>\d+)T(?: +)(?<avail>\d+)T(?: +)(?<usage>\d+)%/

  attr_accessor :x, :y, :size, :used, :avail, :usage

  def initialize string
    args = string.match(NODE_DESCR)
    args.names.each do |name|
      instance_variable_set("@#{name}", args[name].to_i)
    end
  end

  def available_space
    @size - @used
  end

  def pretty_print
    ratio = @used.to_f/@size.to_f
    case
    when ratio >= 0.9
      return "#"
    when ratio >= 0.4
      return "."
    when ratio == 0
      return "_"
    end
  end

  def coords
    [@x, @y]
  end

  def would_fit_in dst
    self.used <= dst.available_space
  end
end

class Grid
  attr_accessor :nodes, :goal

  def initialize file
    @nodes = Hash.new

    File.readlines(file).map do |line|
      if line.match(/\/dev\/grid\/node/)
        n = Node.new(line)
        @nodes[[n.x, n.y]] = n
      end
    end

    # The goal is at x: max, y: 0
    max_x = @nodes.keys.collect(&:last).max
    @goal = {x: max_x, y: 0}
  end

  def adjacent_nodes x, y
    [[x+1, y], [x-1, y], [x, y-1], [x, y+1]]
  end

  def possible_pairs x, y
    src          = @nodes[[x, y]]
    targets      = []

    adjacent_nodes(x, y).each do |this_x, this_y|
      n = @nodes[[this_x, this_y]]
      targets << n unless n.nil?
    end

    targets.select { |node| src.would_fit_in(node) }
  end

  def all_viable_pairs
    viable_pairs = Set.new

    @nodes.values.permutation(2).map do |src, dst|
      next if src.used == 0
      if src.would_fit_in dst
        viable_pairs << [src, dst]
      end
    end

    viable_pairs.size
  end

  def solve
    # we need to move Goal to [0, 0]
    binding.pry
    return 0
  end

  def inspect
    grid = []
    @nodes.map do |coords, node|
      grid[coords.first] = [] if grid[coords.first].nil?
      grid[coords.first][coords.last] = node
    end

    puts "\n"
    puts "-" * grid.size
    grid.transpose.each do |row|
      row.each do |node|
        if [node.x, node.y] == goal.values
          print "G"
        elsif possible_pairs(*node.coords).empty?
          print "#"
        else
          print node.pretty_print
        end
      end
      puts
    end
    puts "-" * grid.size
  end
end

class TestNodeClass < Minitest::Test
  def test_instantiation
    n = Node.new('/dev/grid/node-x0-y0     94T   73T    21T   77%')
    assert_equal 0,  n.x
    assert_equal 0,  n.y
    assert_equal 94, n.size
    assert_equal 73, n.used
    assert_equal 21, n.avail
    assert_equal 77, n.usage
  end
end

class TestGridSolve < Minitest::Test
  def setup
    @grid = Grid.new('test.txt')
  end

  def test_possible_pairs
    pairs = @grid.possible_pairs(1, 2)
    assert_equal 1, pairs.size
    refute_equal [0, 0], [pairs[0].x, pairs[0].y]
  end


  def test_input_from_site
    assert_equal 7, @grid.solve
  end
end

grid = Grid.new('input.txt')
puts "Part 1:"
puts grid.all_viable_pairs
# puts "Part 2"
# puts grid.solve
