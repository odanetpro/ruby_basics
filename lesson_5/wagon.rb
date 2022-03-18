require_relative 'manufacturer'

class Wagon
  include Manufacturer
  attr_reader :number, :type

  def initialize(number)
    @number = number
  end
end
