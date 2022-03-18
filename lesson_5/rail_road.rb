class RailRoad
  def initialize
    # @stations = [Station.new('Москва'), Station.new('Новосибирск'), Station.new('Владивосток')]
    # @routes = [Route.new(@stations[0], @stations[2])]
    # @trains = [PassengerTrain.new('001A'), CargoTrain.new('904')]
    # @wagons = [PassengerWagon.new('p05678'), CargoWagon.new('c78102')]
    @stations = []
    @routes = []
    @trains = []
    @wagons = []
  end

  def main_menu
    actions = { 0 => :menu_error, 1 => :sub_menu_create, 2 => :sub_menu_actions, 3 => :sub_menu_display, 4 => :exit }
    loop do
      puts "\nГлавное меню:"
      puts "Введите 1 чтобы создать (станцию, маршрут, поезд, вагон)"
      puts "Введите 2 чтобы управлять созданными объектами"
      puts "Введите 3 чтобы вывести данные об объектах"
      puts "Введите 4 для выхода из программы\n\n"
      input = gets.to_i
    
      send(actions[input]) if actions.has_key?(input)
    end
  end

  private

  # интерфейс класса - главное меню, все остальные функции не доступны для прямого вызова
  
  def menu_error
    puts "\nВведен неизвестный символ"
  end

  def sub_menu_create
    actions = { 0 => :menu_error, 1 => :create_station, 2 => :create_route, 3 => :create_train, 4 => :create_wagon, 5 => :main_menu }

    loop do
      puts "\nСоздание объектов:"
      puts "Введите 1 чтобы создать станцию"
      puts "Введите 2 чтобы создать маршрут"
      puts "Введите 3 чтобы создать поезд"
      puts "Введите 4 чтобы создать вагон"
      puts "Введите 5 для возврата в главное меню\n\n"
      input = gets.to_i

      send(actions[input]) if actions.has_key?(input)
    end
  end

  def sub_menu_actions
    actions = { 0 => :menu_error, 1 => :add_station_to_route, 2 => :del_station_from_route, 3 => :assign_route_for_train, 4 => :add_wagon_to_train, 5 => :del_wagon_from_train, 6 => :move_train, 7 => :main_menu }

    loop do
      puts "\nУправление объектами:"
      puts "Введите 1 чтобы добавить станцию к маршруту"
      puts "Введите 2 чтобы удалить станцию из маршрута"
      puts "Введите 3 чтобы назначить маршрут поезду"
      puts "Введите 4 чтобы прицепить вагон к поезду"
      puts "Введите 5 чтобы отцепить вагон от поезда"
      puts "Введите 6 чтобы переместить поезд"
      puts "Введите 7 для возврата в главное меню\n\n"
      input = gets.to_i

      send(actions[input]) if actions.has_key?(input)
    end
  end

  def sub_menu_display
    actions = { 0 => :menu_error, 1 => :display_stations, 2 => :display_trains_on_station, 3 => :main_menu }

    loop do
      puts "\nВывод информации:"
      puts "Введите 1 чтобы посмотреть список станций"
      puts "Введите 2 чтобы посмотреть список поездов на станции"
      puts "Введите 3 для возврата в главное меню\n\n"
      input = gets.to_i

      send(actions[input]) if actions.has_key?(input)
    end
  end

  def create_station
    print "\nВведите название станции: "
    title = gets.strip.capitalize
    @stations << Station.new(title)
  end

  def create_route
    display_stations

    print "\nВведите номер начальной станции маршрута: "
    from = @stations[gets.to_i - 1]

    print "\Введите номер конечной станциии маршрута: "
    to = @stations[gets.to_i - 1]

    @routes << Route.new(from, to) if from && to
  end

  def create_train
    print "\nВведите номер поезда: "
    number = gets.strip.capitalize

    print "Грузовой или пассажирский? (г/п): "
    type = gets.strip.downcase

    if type == 'г'
      @trains << CargoTrain.new(number)
    elsif type == 'п'
      @trains << PassengerTrain.new(number)
    else
      menu_error
    end
  end

  def create_wagon
    print "\nВведите номер вагона: "
    number = gets.strip.capitalize

    print "Грузовой или Пассажирский? (г/п): "
    type = gets.strip.downcase

    if type == 'г'
      @trains << CargoWagon.new(number)
    elsif type == 'п'
      @trains << PassengerWagon.new(number)
    else
      menu_error
    end
  end

  def add_station_to_route
    display_routes
    print "\nВведите номер маршрута: "
    route = @routes[gets.to_i - 1]

    display_stations
    print "\nВведите номер станции чтобы добавить к маршруту: "
    station = @stations[gets.to_i - 1]

    display_route(route)
    print "\nВведите номер станции после которой необходимо добавить: "
    prev_station = route.stations[gets.to_i - 1]

    route.add_station(prev_station, station)
  end

  def del_station_from_route
    display_routes
    print "\nВведите номер маршрута: "
    route = @routes[gets.to_i - 1]

    display_route(route)
    print "\nВведите номер станции, чтобы удалить из маршрута: "
    station = route.stations[gets.to_i - 1]

    route.del_station(station)
  end

  def assign_route_for_train
    display_trains
    print "\nВведите номер поезда: "
    train = @trains[gets.to_i - 1]

    display_routes
    print "\nВведите номер маршрута чтобы назначить поезду: "
    route = @routes[gets.to_i - 1]

    train.assign_route(route) if train && route
  end

  def add_wagon_to_train
    display_trains
    print "\nВведите номер поезда: "
    train = @trains[gets.to_i - 1]

    display_wagons
    print "\nВведите номер вагона, чтобы прицепить к поезду: "
    wagon = @wagons[gets.to_i - 1]

    train.add_wagon(wagon) if train && wagon
  end

  def del_wagon_from_train
    display_trains
    print "\nВведите номер поезда: "
    train = @trains[gets.to_i - 1]

    train.display_wagons
    print "\nВведите номер вагона, чтобы отцепить от поезда: "
    wagon = @wagons[gets.to_i - 1]

    train.del_wagon(wagon) if train && wagon
  end

  def move_train
    display_trains
    print "\nВведите номер поезда: "
    train = @trains[gets.to_i - 1]

    print "\nНа какую станцию отправлять поезд? (1 - на следующую, 2 - на предыдущую): "
    input = gets.to_i

    if input == 1
      train.move_next_station
    elsif input == 2
      train.move_prev_station
    else
      menu_error
    end
  end

  def display_wagons
    puts "\nСписок вагонов:"
    @wagons.each_with_index { |wagon, i| puts "#{i + 1}. #{wagon.number}" }
  end

  def display_trains
    puts "\nСписок поездов:"
    @trains.each_with_index { |train, i| puts "#{i + 1}. #{train.number}" }
  end

  def display_route(route)
    puts "\nМаршрут:"
    route.stations.each_with_index { |station, i| puts "#{i + 1}. #{station.title}" }
  end

  def display_routes
    puts "\nСписок маршрутов:"
    @routes.each_with_index { |route, i| puts "#{i + 1}. #{route.stations[0].title} - #{route.stations[-1].title}" }
  end

  def display_stations
    puts "\nСписок станций:"
    @stations.each_with_index { |station, i| puts "#{i + 1}. #{station.title}" }
  end

  def display_trains_on_station
    display_stations
    print "\nВведите номер станции: "
    station = @stations[gets.to_i - 1]

    if station
      puts "\nНа станции #{station.title}:"

      puts "\nГрузовые поезда:"
      station.cargo_trains_list.each { |train| puts "#{train.number}" }
      puts "всего: #{station.cargo_trains_amount}"

      puts "\nПассажирские поезда:"
      station.passenger_trains_list.each { |train| puts "#{train.number}" }
      puts "всего: #{station.passenger_trains_amount}"
    else
      puts "\nСтанция не найдена"
    end
  end
end
