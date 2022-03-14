class Route
  attr_reader :stations

  def initialize(from, to)
    @stations = [from, to]
  end

  def add_station(prev_station, station)
    index = @stations.index(prev_station)
    @stations.insert(index + 1, station) if index < @stations.size - 1
  end
  
  def del_station(station)
    @stations.delete(station) if station != @stations[0] && station != @stations[-1]
  end

  def display
    puts "\nМаршрут:"
    self.stations.each_with_index { |station, i| puts "#{i + 1}. #{station.title}" }
  end
end
