require_relative 'instance_counter'

class Station
  include InstanceCounter
  attr_reader :title, :trains

  @@stations = []

  def initialize(title)
    @title = title
    @trains = []
    @@stations << self
    register_instance
  end

  def self.all
    @@stations
  end

  def add_train(train)
    @trains << train
  end

  def del_train(train)
    @trains.delete(train)
  end

  def cargo_trains_amount
    trains_amount(CargoTrain)
  end

  def passenger_trains_amount
    trains_amount(PassengerTrain)
  end

  def cargo_trains_list
    train_list(CargoTrain)
  end

  def passenger_trains_list
    train_list(PassengerTrain)
  end
  
  private

  # чтобы вне класса для подсчета поездов не задавать параметр "имя класса", созданы public методы 
  # которые прячут от пользователя вызов этотого параметра и передают его данному private методу
  def train_list(class_name)
    self.trains.select { |train| train.is_a?(class_name) }
  end

  # аналогично предыдущему
  # метод private, а не protected потому что на данный момент у класса Station не предполагются наследники
  def trains_amount(class_name)
    self.trains.count { |train| train.is_a?(class_name) }
  end
end
