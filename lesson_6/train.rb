require_relative 'manufacturer'
require_relative 'instance_counter'

class Train
  include Manufacturer
  include InstanceCounter
  attr_reader :number, :wagons, :speed, :current_station, :type
  
  NUMBER_FORMAT = /^[а-яa-z0-9]{3}-*[а-яa-z0-9]{2}$/i

  @@all = []

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
    @@all << self
    register_instance
    validate!
  end

  def valid?
    validate!
    true
  rescue RuntimeError
    false
  end
  
  def self.all
    @@all
  end

  def self.find(train_number)
    @@all.each { |train| return train if train.number.downcase == train_number.downcase }
    nil
  end

  def start(speed)
    @speed = speed
  end

  def stop
    @speed = 0
  end

  def add_wagon(wagon)
    @wagons << wagon if self.speed == 0 && wagon.type == self.type
  end

  def del_wagon(wagon)
    @wagons.delete(wagon) if self.speed == 0
  end

  def assign_route(route)
    @route = route
    @current_station = route.stations.first
    @current_station.add_train(self)
  end

  def move_next_station
    station = next_station
    if station
      @current_station.del_train(self)
      @current_station = station
      station.add_train(self)
    else 
      raise "Нельзя переместить поезд на следующую станцию"
    end
  end

  def move_prev_station
    station = prev_station
    if station
      @current_station.del_train(self)
      @current_station = station
      station.add_train(self)
    else 
      raise "\nНельзя переместить поезд на предыдущую станцию"
    end
  end

  def next_station
    index = @route.stations.index(self.current_station)
    @route.stations[index + 1] if index && index != @route.stations.size - 1
  end

  def prev_station
    index = @route.stations.index(self.current_station)
    @route.stations[index - 1] if index && index > 0
  end

  def display_wagons
    self.wagons.each_with_index { |wagon, i| puts "#{i + 1}. #{wagon.number}" }
  end

  def cargo?
    self.type == :cargo
  end

  def passenger?
    self.type == :passenger
  end

  protected

  def validate!
    raise "Номер поезда не может быть пустым!" if self.number.empty? || self.number.nil?
    raise "Неверный формат номера поезда!" if self.number !~ NUMBER_FORMAT
  end
end
