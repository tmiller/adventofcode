require 'pry'
require_relative 'assembunny'

CORRECT_SEQUENCE = /(01)+|(010)+/

def evaluate_tape state
end

computer = Computer.new
computer.load('input.txt')
computer.execute { |c| evaluate_tape c }
