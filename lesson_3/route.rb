class Route
  attr_reader :stations

  def initialize(from, to)
    @stations = [from, to]
  end

  def add_station(index, station)
    @stations.insert(index, station) if (1...@stations.size).include?(index)
  end
  
  def del_station(station)
    @stations.delete(station)
  end

  def display
    self.stations.each { |station| puts "#{station.title}" }
  end
end
