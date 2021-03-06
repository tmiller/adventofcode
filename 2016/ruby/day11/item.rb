class Item
  include Comparable

  attr_accessor :mineral, :type, :floor

  def initialize description, floor_number
    values   = description.split(/ |-compatible/)
    @mineral = values.first.to_sym
    @type    = values.last.to_sym

    @floor = floor_number
  end

  def compatible? other_item
    return @mineral == other_item.mineral
  end

  def id
    "#{@mineral.capitalize} #{@type.capitalize}".to_sym
  end

  def move_up
    move(1)
  end

  def move_down
    move(-1)
  end

  def to_s
    return id
  end

  def <=> obj
    self.id <=> obj.id
  end

  private

  def move num
    target_floor = @floor + num
    @floor = target_floor if (0..3).member? target_floor
  end
end

