class Train
  attr_reader :number, :type, :wagons, :speed, :current_station
  
  def initialize(number, type, wagons)
    @number = number
    @type = type
    @wagons = wagons
    @speed = 0
  end

  def start(speed)
    @speed = speed
  end

  def stop
    @speed = 0
  end

  def add_wagon
    @wagons += 1 if self.speed == 0
  end

  def del_wagon
    @wagons -= 1 if self.speed == 0 && self.wagons > 0
  end

  def assign_route(route)
    @route = route
    @current_station = route.stations.first
    route.stations.first.add_train(self)
  end

  def next_station
    index = @route.stations.find_index(self.current_station)
    @route.stations[index + 1] if index && index != @route.stations.size - 1
  end

  def prev_station
    index = @route.stations.find_index(self.current_station)
    @route.stations[index - 1] if index && index > 0
  end

  def move_next_station
    station = next_station
    station ? (@current_station = station) : (puts 'Нельзя переместить поезд на следующую станцию')
  end

  def move_prev_station
    station = prev_station
    station ? (@current_station = station) : (puts 'Нельзя переместить поезд на предыдущую станцию')
  end
end
