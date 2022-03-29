# frozen_string_literal: false

require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'

@stations = [Station.new('Москва'), Station.new('Новосибирск'), Station.new('Владивосток')]
@routes = [Route.new(@stations[0], @stations[2])]
@trains = [PassengerTrain.new('001-AA'), CargoTrain.new('904-28')]
@wagons = [PassengerWagon.new('p05678', 3), CargoWagon.new('c78102', 1000)]
@trains[0].assign_route(@routes[0])
# @stations = []
# @routes = []
# @trains = []
# @wagons = []

# основа для меню
@main_menu_basis = {
  1 => [:sub_menu_create, 'Введите 1 чтобы создать (станцию, маршрут, поезд, вагон)'],
  2 => [:sub_menu_actions, 'Введите 2 чтобы управлять созданными объектами'],
  3 => [:sub_menu_display, 'Введите 3 чтобы вывести данные об объектах'],
  4 => [:exit, 'Введите 4 для выхода из программы']
}

@menu_create_basis = {
  1 => [:ask_create_station, 'Введите 1 чтобы создать станцию'],
  2 => [:ask_create_route, 'Введите 2 чтобы создать маршрут'],
  3 => [:ask_create_train, 'Введите 3 чтобы создать поезд'],
  4 => [:ask_create_wagon, 'Введите 4 чтобы создать вагон'],
  5 => [:main_menu, 'Введите 5 для возврата в главное меню']
}

@menu_actions_basis = {
  1 => [:add_station_to_route, 'Введите 1 чтобы добавить станцию к маршруту'],
  2 => [:del_station_from_route, 'Введите 2 чтобы удалить станцию из маршрута'],
  3 => [:assign_route_for_train, 'Введите 3 чтобы назначить маршрут поезду'],
  4 => [:add_wagon_to_train, 'Введите 4 чтобы прицепить вагон к поезду'],
  5 => [:del_wagon_from_train, 'Введите 5 чтобы отцепить вагон от поезда'],
  6 => [:ask_move_train, 'Введите 6 чтобы переместить поезд'],
  7 => [:fill_wagon, 'Введите 7 чтобы заполнить вагон (пассажирами или грузом)'],
  8 => [:main_menu, 'Введите 8 для возврата в главное меню']
}

@menu_display_basis = {
  1 => [:display_stations, 'Введите 1 чтобы посмотреть список станций'],
  2 => [:display_station_trains, 'Введите 2 чтобы посмотреть список поездов на станции'],
  3 => [:display_train_wagons, 'Введите 3 чтобы вывести список вагонов у поезда'],
  4 => [:main_menu, 'Введите 4 для возврата в главное меню']
}

# методы для работы с меню
def show_menu(title, menu_basis)
  loop do
    puts "\n#{title}\n\n"
    menu_basis.each_value { |value| puts value[1] }

    action = menu_basis.dig(gets.to_i, 0) || show_menu_error
    send(action)
  end
end

def show_menu_error
  puts "\nВведен неизвестный символ"
end

def main_menu
  show_menu('Главное меню:', @main_menu_basis)
end

def sub_menu_create
  show_menu('Создание объектов:', @menu_create_basis)
end

def sub_menu_actions
  show_menu('Управление объектами:', @menu_actions_basis)
end

def sub_menu_display
  show_menu('Вывод информации:', @menu_display_basis)
end

# методы для создания объектов
def ask_create_station
  print "\nВведите название станции: "
  title = gets.strip.capitalize

  @stations << Station.new(title)
  puts "\nСоздана станция #{title}"
rescue RuntimeError => e
  puts e.message.to_s
  retry
end

def ask_create_route
  display_stations

  print "\nВведите номер начальной станции маршрута: "
  from = @stations[gets.to_i - 1]

  print "\nВведите номер конечной станциии маршрута: "
  to = @stations[gets.to_i - 1]

  create_route(from, to)
rescue StandardError => e
  puts e.message.to_s
  retry
end

def create_route(from, to)
  @routes << Route.new(from, to)
  puts "\nСоздан маршрут #{from.title} - #{to.title}"
end

def ask_create_train
  print "\nВведите номер поезда: "
  number = gets.strip

  print 'Грузовой или пассажирский? (г/п): '
  type = gets.strip.downcase

  create_train(number, type) if %w[г п].include?(type)
rescue StandardError => e
  puts e.message.to_s
  retry
end

def create_train(number, type)
  case type
  when 'г'
    @trains << CargoTrain.new(number)
  when 'п'
    @trains << PassengerTrain.new(number)
  end
  puts "Поезд № #{number} создан"
end

def ask_create_wagon
  print "\nВведите номер вагона: "
  number = gets.strip

  print 'Грузовой или Пассажирский? (г/п): '
  type = gets.strip.downcase

  create_passenger_wagon(number) if type == 'п'
  create_cargo_wagon(number) if type == 'г'
rescue RuntimeError => e
  puts e.message.to_s
  retry
end

def create_passenger_wagon(number)
  print 'Введите общее количество мест: '
  total_seats = gets.to_i

  @wagons << PassengerWagon.new(number, total_seats)
  puts "\nСоздан пассажирский вагон № #{number}, число мест: #{total_seats}"
end

def create_cargo_wagon(number)
  print 'Введите общий объем (м3): '
  total_volume = gets.to_f

  @wagons << CargoWagon.new(number, total_volume)
  puts "\nСоздан грузовой вагон № #{number}, общим объемом #{total_volume} (м3)"
end

# методы для управления объектами
def add_station_to_route
  route = choose_route

  display_stations
  print "\nВведите номер станции чтобы добавить к маршруту: "
  station = @stations[gets.to_i - 1]

  display_route(route)
  print "\nВведите номер станции после которой необходимо добавить: "
  prev_station = route.stations[gets.to_i - 1]

  route.add_station(prev_station, station)
end

def del_station_from_route
  route = choose_route

  display_route(route)
  print "\nВведите номер станции, чтобы удалить из маршрута: "
  station = route.stations[gets.to_i - 1]

  route.del_station(station)
end

def assign_route_for_train
  train = choose_train

  display_routes
  print "\nВведите номер маршрута чтобы назначить поезду: "
  route = @routes[gets.to_i - 1]

  train.assign_route(route) if train && route
end

def add_wagon_to_train
  train = choose_train

  display_wagons(@wagons)
  print "\nВведите номер вагона, чтобы прицепить к поезду: "
  wagon = @wagons[gets.to_i - 1]

  train.add_wagon(wagon) if train && wagon
end

def del_wagon_from_train
  train = choose_train

  puts "\nВагоны:"
  display_wagons(train.wagons)
  print "\nВведите номер вагона, чтобы отцепить от поезда: "
  wagon = @wagons[gets.to_i - 1]

  train.del_wagon(wagon) if train && wagon
end

def ask_move_train
  train = choose_train

  print "\nНа какую станцию отправлять поезд? (1 - на следующую, 2 - на предыдущую): "
  direction = gets.to_i

  move_train(train, direction) if [1, 2].include?(direction)
rescue RuntimeError => e
  puts e.message.to_s
end

def move_train(train, direction)
  direction == 1 ? train.move_next_station : train.move_prev_station
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
  passenger_wagons = @wagons.select(&:passenger?)
  display_wagons passenger_wagons

  print "\nВведите номер вагона, чтобы занять место: "
  wagon = passenger_wagons[gets.to_i - 1]

  puts wagon.take_seat ? "\nМесто успешно занято" : "\nНе осталось свободных мест!"
end

# методы для вывода различной информации
def display_wagons(wagons)
  puts "\nСписок вагонов:"
  wagons.each_with_index do |wagon, i|
    if wagon.passenger?
      puts "#{i + 1}. № #{wagon.number}, пасс., занято мест: #{wagon.occupied_seats}, свободно: #{wagon.empty_seats}"
    elsif wagon.cargo?
      puts "#{i + 1}. № #{wagon.number}, груз., занято м3: #{wagon.occupied_volume}, свободно: #{wagon.empty_volume}"
    end
  end
end

def display_train_wagons
  train = choose_train
  display_wagons(train.wagons)
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

def display_station_trains
  display_stations
  print "\nВведите номер станции: "
  station = @stations[gets.to_i - 1]
  puts "\nСтанция не найдена" unless station

  puts "\nПоезда на станции #{station.title}:"
  station.trains.each_with_index do |train, i|
    type = train.passenger? ? 'пассажирский' : 'грузовой'
    puts "#{i}. номер: #{train.number}, тип: #{type}, вагонов: #{train.wagons.size}"
  end
end

# методы для выбора объектов
def choose_route
  display_routes
  print "\nВведите номер маршрута: "
  @routes[gets.to_i - 1]
end

def choose_train
  display_trains
  print "\nВведите номер поезда: "
  @trains[gets.to_i - 1]
end

main_menu
