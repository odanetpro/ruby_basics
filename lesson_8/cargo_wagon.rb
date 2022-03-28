# frozen_string_literal: false

class CargoWagon < Wagon
  attr_reader :total_volume, :occupied_volume

  def initialize(number, total_volume)
    @type = :cargo
    @total_volume = total_volume
    @occupied_volume = 0
    super number
  end

  def take_volume(volume)
    v = occupied_volume + volume
    self.occupied_volume = v if v <= total_volume
  end

  def empty_volume
    total_volume - occupied_volume
  end

  protected

  attr_writer :occupied_volume

  def validate!
    super
    raise 'Общий объем не может быть пустым!' if total_volume.nil?
  end
end
