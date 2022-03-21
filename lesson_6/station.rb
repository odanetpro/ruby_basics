require_relative 'instance_counter'

class Station
  include InstanceCounter
  attr_reader :title, :trains

  @@all = []

  def initialize(title)
    @title = title
    @trains = []
    @@all << self
    register_instance
    validate!
  end

  def self.all
    @@all
  end

  def valid?
    validate!
    true
  rescue RuntimeError
    false
  end

  def add_train(train)
    @trains << train
  end

  def del_train(train)
    @trains.delete(train)
  end

  def cargo_trains_amount
    self.trains.count { |train| train.cargo? }
  end

  def passenger_trains_amount
    self.trains.count { |train| train.passenger? }
  end

  def cargo_trains_list
    self.trains.select { |train| train.cargo? }
  end

  def passenger_trains_list
    self.trains.select { |train| train.passenger? }
  end
  
  private

  def validate!
    raise "Название станции не может быть пустым!" if self.title.empty? || self.title.nil?
  end
end
