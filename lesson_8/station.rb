# frozen_string_literal: false

require_relative 'instance_counter'

class Station
  include InstanceCounter
  attr_reader :title

  def initialize(title)
    @title = title
    @trains = []
    register_instance
    validate!
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
    trains.count(&:cargo?)
  end

  def passenger_trains_amount
    trains.count(&:passenger?)
  end

  def cargo_trains_list
    trains.select(&:cargo?)
  end

  def passenger_trains_list
    trains.select(&:passenger?)
  end

  def trains(&block)
    return @trains unless block_given?

    @trains.each(&block)
  end

  private

  def validate!
    raise 'Название станции не может быть пустым!' if title.empty? || title.nil?
  end
end
