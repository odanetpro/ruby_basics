# frozen_string_literal: false

require_relative 'manufacturer'
require_relative 'instance_counter'

class Train
  include Manufacturer
  include InstanceCounter
  attr_reader :number, :speed, :current_station, :type

  # 3 буквы/цифры (обязат.) - (необязат)  2 буквы/цифры (обязат.)
  NUMBER_FORMAT = /^[а-яa-z0-9]{3}-*[а-яa-z0-9]{2}$/i.freeze

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
    register_instance
    validate!
  end

  def valid?
    validate!
    true
  rescue RuntimeError
    false
  end

  def start(speed)
    @speed = speed
  end

  def stop
    @speed = 0
  end

  def add_wagon(wagon)
    @wagons << wagon if speed.zero? && wagon.type == type
  end

  def del_wagon(wagon)
    @wagons.delete(wagon) if speed.zero?
  end

  def assign_route(route)
    @route = route
    @current_station = route.stations.first
    @current_station.add_train(self)
  end

  def move_next_station
    station = next_station
    raise 'Нельзя переместить поезд на следующую станцию' unless station

    @current_station.del_train(self)
    @current_station = station
    station.add_train(self)
  end

  def move_prev_station
    station = prev_station
    raise 'Нельзя переместить поезд на предыдущую станцию' unless station

    @current_station.del_train(self)
    @current_station = station
    station.add_train(self)
  end

  def next_station
    index = @route.stations.index(current_station)
    @route.stations[index + 1] if index && index != @route.stations.size - 1
  end

  def prev_station
    index = @route.stations.index(current_station)
    @route.stations[index - 1] if index&.positive?
  end

  def cargo?
    type == :cargo
  end

  def passenger?
    type == :passenger
  end

  def wagons(&block)
    return @wagons unless block_given?

    @wagons.each(&block)
  end

  protected

  def validate!
    raise 'Номер поезда не может быть пустым!' if number.empty? || number.nil?
    raise 'Неверный формат номера поезда!' if number !~ NUMBER_FORMAT
  end
end
