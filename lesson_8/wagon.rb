# frozen_string_literal: false

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
    type == :cargo
  end

  def passenger?
    type == :passenger
  end

  protected

  def validate!
    raise 'Номер вагона не может быть пустым!' if number.empty? || number.nil?
  end
end
