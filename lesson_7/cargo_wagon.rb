class CargoWagon < Wagon
  attr_reader :total_volume, :occupied_volume
  
  def initialize(number, total_volume)
    @type = :cargo
    @total_volume = total_volume
    @occupied_volume = 0
    super number
  end

  def take_volume(volume)
    v = self.occupied_volume + volume
    self.occupied_volume = v if v <= self.total_volume
  end

  def empty_volume
    self.total_volume - self.occupied_volume 
  end

  protected

  attr_writer :occupied_volume

  def validate!
    super
    raise "Общий объем не может быть пустым!" if self.total_volume.nil?
  end
end
