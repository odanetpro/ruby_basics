require './station.rb'
require './route.rb'
require './train.rb'

# создадим станции
moscow = Station.new('Москва')
klin = Station.new('Клин')
tver = Station.new('Тверь')
spb = Station.new('Санкт-Петербург')
vvo = Station.new('Владивосток')
nsk = Station.new('Новосибирск')

# маршрут Москва - Санкт-Петербург
msk_spb = Route.new(moscow, spb)

msk_spb.add_station(1, klin)
msk_spb.add_station(2, tver)
msk_spb.del_station(klin)
msk_spb.display

# маршрут Москва - Владивосток
msk_vvo = Route.new(moscow, vvo)
msk_vvo.add_station(1, nsk)

# создадим поезда
red_arrow = Train.new('001A', :passenger, 17)
n904 = Train.new('904', :cargo, 35)

red_arrow.start(100)
puts "#{red_arrow.speed} км/ч"

# когда поезд едет, вагоны не добавляются
red_arrow.add_wagon
puts red_arrow.wagons

red_arrow.stop

# когда остановился - все работает
red_arrow.add_wagon
puts red_arrow.wagons
red_arrow.del_wagon
puts red_arrow.wagons

# назначим поезду маршрут
red_arrow.assign_route(msk_spb)

# покажем текущую и следующую станцию
puts red_arrow.current_station.title
puts red_arrow.next_station.title

# подвигаем поезд
red_arrow.move_next_station
puts red_arrow.current_station.title

red_arrow.move_prev_station
puts red_arrow.current_station.title

# добавим поезд на станцию
moscow.add_train(n904)

# покажем поезда на станции Москва
moscow.trains.each { |train| puts train.number }
puts moscow.trains_amount(:cargo)
moscow.trains_list(:passenger).each { |train| puts train.number }
