class State
  attr_accessor :elevator, :items

  def initialize
    @elevator = 0
    @items    = Set.new
  end

  def valid?
    rtgs = @items.select { |x| x.type == :generator }
    chps = @items.select { |x| x.type == :microchip }

    # if any chip is in a room with a non-matching RTG without shield, fail
    chps.each do |chip|
      if rtgs.map(&:floor).member? chip.floor &&
          rtgs.find { |rtg| rtg.compatible? chip }.floor != chip.floor
        return false
      end
    end
    return true
  end

  def clone
    Marshal::load(Marshal.dump(self))
  end

  def inspect
    str = ""
    [3,2,1,0].each do |floor|
      if @elevator == floor
        elevator = "E"
      else
        elevator = " "
      end
      str += "F#{floor+1}:#{elevator}: #{@items.select{|x| x.floor == floor}.sort.map(&:to_s)}\n"
    end
    return str
  end

  def eql?(obj)
    self.inspect == obj.inspect && self.class == obj.class
  end

  def hash
    self.inspect.hash
  end

  def possible_states
    states = Set.new

    moveable_items = @items.select { |i| i.floor == @elevator }
    
    item_combos = moveable_items.combination(2).to_a + 
                  moveable_items.combination(1).to_a

    # the move method is contructed to do nothing if impossible
    # because this is the same state, it should get filtered out in the set
    item_combos.map do |items|
      if @elevator != 3
        tmp_state = self.clone
        items.map do |item|
          tmp_state.items.find{ |x| x.id == item.id }.move_up
        end
        tmp_state.elevator += 1
        states << tmp_state
      end

      if @elevator != 0
        tmp_state = self.clone
        items.map do |item|
          tmp_state.items.find{ |x| x.id == item.id }.move_down
        end
        tmp_state.elevator -= 1
        states << tmp_state
      end
    end

    return states
  end

  def victory?
    @items.map { |item| item.floor == 3 }.inject(:&)
  end
end

