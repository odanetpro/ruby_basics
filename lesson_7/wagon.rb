require_relative 'manufacturer'

class Wagon
  include Manufacturer
  attr_reader :number, :type

  def initialize(number)
    @number = number
    validate!
  end

  def valid?
    validate!
    true
  rescue RuntimeError
    false
  end

  def cargo?
    self.type == :cargo
  end

  def passenger?
    self.type == :passenger
  end

  protected

  def validate!
    raise "Номер вагона не может быть пустым!" if self.number.empty? || self.number.nil?
  end
end
