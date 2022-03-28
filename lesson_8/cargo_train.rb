# frozen_string_literal: false

class CargoTrain < Train
  def initialize(number)
    super
    @type = :cargo
  end
end
