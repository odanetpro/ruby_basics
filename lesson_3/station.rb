class Station
  attr_reader :title, :trains

  def initialize(title)
    @title = title
    @trains = []
  end

  def add_train(train)
    @trains << train
  end

  def del_train(train)
    @trains.delete(train)
  end

  def trains_amount(train_type)
    self.trains.count { |train| train.type == train_type }
  end

  def trains_list(train_type)
    self.trains.select { |train| train.type == train_type }
  end
end
