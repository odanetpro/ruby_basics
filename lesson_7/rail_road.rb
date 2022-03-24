class RailRoad
  def initialize
    @stations = [Station.new('Москва'), Station.new('Новосибирск'), Station.new('Владивосток')]
    @routes = [Route.new(@stations[0], @stations[2])]
    @trains = [PassengerTrain.new('001-AA'), CargoTrain.new('904-28')]
    @wagons = [PassengerWagon.new('p05678', 3), CargoWagon.new('c78102', 1000)]
    @trains[0].assign_route(@routes[0])
    # @stations = []
    # @routes = []
    # @trains = []
    # @wagons = []
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
    actions = {
      0 => :menu_error,
      1 => :add_station_to_route,
      2 => :del_station_from_route,
      3 => :assign_route_for_train,
      4 => :add_wagon_to_train,
      5 => :del_wagon_from_train,
      6 => :move_train,
      7 => :fill_wagon,
      8 => :main_menu
    }

    loop do
      puts "\nУправление объектами:"
      puts "Введите 1 чтобы добавить станцию к маршруту"
      puts "Введите 2 чтобы удалить станцию из маршрута"
      puts "Введите 3 чтобы назначить маршрут поезду"
      puts "Введите 4 чтобы прицепить вагон к поезду"
      puts "Введите 5 чтобы отцепить вагон от поезда"
      puts "Введите 6 чтобы переместить поезд"
      puts "Введите 7 чтобы заполнить вагон (пассажирами или грузом)"
      puts "Введите 8 для возврата в главное меню\n\n"
      input = gets.to_i

      send(actions[input]) if actions.has_key?(input)
    end
  end

  def sub_menu_display
    actions = { 0 => :menu_error, 1 => :display_stations, 2 => :display_trains_on_station, 3 => :display_train_wagons, 4 => :main_menu }

    loop do
      puts "\nВывод информации:"
      puts "Введите 1 чтобы посмотреть список станций"
      puts "Введите 2 чтобы посмотреть список поездов на станции"
      puts "Введите 3 чтобы вывести список вагонов у поезда"
      puts "Введите 4 для возврата в главное меню\n\n"
      input = gets.to_i

      send(actions[input]) if actions.has_key?(input)
    end
  end

  def create_station
    print "\nВведите название станции: "
    title = gets.strip.capitalize
    
    @stations << Station.new(title)
    puts "\nСоздана станция #{title}"

  rescue RuntimeError => e
    puts "#{e.message}"
    retry
  end

  def create_route
    display_stations

    print "\nВведите номер начальной станции маршрута: "
    from = @stations[gets.to_i - 1]

    print "\Введите номер конечной станциии маршрута: "
    to = @stations[gets.to_i - 1]
    
    @routes << Route.new(from, to)
    puts "\nСоздан маршрут #{from.title} - #{to.title}"

  rescue RuntimeError => e
    puts "#{e.message}"
    retry
  end

  def create_train
    print "\nВведите номер поезда: "
    number = gets.strip

    print "Грузовой или пассажирский? (г/п): "
    type = gets.strip.downcase

    if type == 'г'
      @trains << CargoTrain.new(number)
      type = 'грузовой'
    elsif type == 'п'
      @trains << PassengerTrain.new(number)
      type = 'пассажирский'
    else
      menu_error
    end
    
    puts "\nСоздан #{type} поезд № #{number}"

  rescue RuntimeError => e
    puts "#{e.message}"
    retry
  end

  def create_wagon
    print "\nВведите номер вагона: "
    number = gets.strip

    print "Грузовой или Пассажирский? (г/п): "
    type = gets.strip.downcase

    if type == 'г'
      print "Введите общий объем (м3): "
      total_volume = gets.to_f

      @wagons << CargoWagon.new(number, total_volume)
      puts "\nСоздан грузовой вагон № #{number}, общим объемом #{total_volume} (м3)"
    elsif type == 'п'
      print "Введите общее количество мест: "
      total_seats = gets.to_i
      
      @wagons<< PassengerWagon.new(number, total_seats)
      puts "\nСоздан пассажирский вагон № #{number}, число мест: #{total_seats}"
    else
      menu_error
    end

  rescue RuntimeError => e
    puts "#{e.message}"
    retry
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

    display_wagons(@wagons)
    print "\nВведите номер вагона, чтобы прицепить к поезду: "
    wagon = @wagons[gets.to_i - 1]

    train.add_wagon(wagon) if train && wagon
  end

  def del_wagon_from_train
    display_trains
    print "\nВведите номер поезда: "
    train = @trains[gets.to_i - 1]

    puts "\nВагоны:"
    display_wagons(train.wagons)
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

  rescue RuntimeError => e
    puts "#{e.message}"
  end

  def fill_wagon
    display_wagons(@wagons) 
    print "\nВведите номер вагона, чтобы заполнить: "
    wagon = @wagons[gets.to_i - 1]

    if wagon.passenger?
      puts wagon.take_seat ? "\nМесто в вагоне успешно занято" : "\nНе осталось свободных мест!"
    elsif wagon.cargo?
      print "\Введите объем для загрузки (м3): "
      volume = gets.to_f

      puts wagon.take_volume(volume) ? "\nОбъем успешно заполнен" : "\nНе достаточно свободного объема!"
    end
  end

  def take_seat
    passenger_wagons = @wagons.select { |wagon| wagon.passenger? }
    display_wagons passenger_wagons

    print "\nВведите номер вагона, чтобы занять место: "
    wagon = passenger_wagons[gets.to_i - 1]

    puts wagon.take_seat ? "\nМесто успешно занято" : "\nНе осталось свободных мест!"
  end

  def display_wagons(wagons)
    puts "\nСписок вагонов:"
    wagons.each_with_index do |wagon, i|
      if wagon.passenger?
        puts "#{i + 1}. номер: #{wagon.number}, тип: пассажирский,  занято (мест): #{wagon.occupied_seats}, свободно (мест): #{wagon.empty_seats}"
      elsif wagon.cargo?
        puts "#{i + 1}. номер: #{wagon.number}, тип: грузовой, занято (м3): #{wagon.occupied_volume}, свободно (м3): #{wagon.empty_volume}" 
      end
    end
  end

  def display_train_wagons
    display_trains
    print "\nВведите номер поезда: "
    train = @trains[gets.to_i - 1]

    puts "\nВагоны:"
    i = 1
    train.wagons do |wagon|
      if wagon.passenger?
        puts "#{i}. номер: #{wagon.number}, тип: пассажирский,  занято (мест): #{wagon.occupied_seats}, свободно (мест): #{wagon.empty_seats}"
      elsif wagon.cargo?
        puts "#{i}. номер: #{wagon.number}, тип: грузовой, занято (м3): #{wagon.occupied_volume}, свободно (м3): #{wagon.empty_volume}" 
      end
      i += 1
    end
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
    puts "\nСтанция не найдена" unless station
    
    i = 1
    puts "\nПоезда на станции #{station.title}:"
    station.trains do |train| 
      if train.passenger?
        type = "пассажирский"
      elsif train.cargo?
        type = "грузовой"
      end

      puts "#{i}. номер: #{train.number}, тип: #{type}, вагонов: #{train.wagons.size}"
      i += 1
    end
  end

  # def display_trains_on_station
  #   display_stations
  #   print "\nВведите номер станции: "
  #   station = @stations[gets.to_i - 1]

  #   if station
  #     puts "\nНа станции #{station.title}:"

  #     puts "\nГрузовые поезда:"
  #     station.cargo_trains_list.each { |train| puts "#{train.number}" }
  #     puts "всего: #{station.cargo_trains_amount}"

  #     puts "\nПассажирские поезда:"
  #     station.passenger_trains_list.each { |train| puts "#{train.number}" }
  #     puts "всего: #{station.passenger_trains_amount}"
  #   else
  #     puts "\nСтанция не найдена"
  #   end
  # end
end
