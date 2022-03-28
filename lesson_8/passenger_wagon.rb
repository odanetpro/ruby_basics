# frozen_string_literal: false

class PassengerWagon < Wagon
  attr_reader :total_seats, :occupied_seats

  def initialize(number, total_seats)
    @type = :passenger
    @total_seats = total_seats
    @occupied_seats = 0
    super number
  end

  def take_seat
    n = occupied_seats + 1
    self.occupied_seats = n if n <= total_seats
  end

  def empty_seats
    total_seats - occupied_seats
  end

  protected

  attr_writer :occupied_seats

  def validate!
    super
    raise 'Общее количество мест не может быть пустым!' if total_seats.nil?
  end
end
