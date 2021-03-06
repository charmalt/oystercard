# require 'pry'
# require 'pry-byebug'
class Journey

  MIN_FARE = 1
  PENALTY_FARE = 6
  attr_reader :entry_station, :exit_station, :fare

  def initialize(entry_station = nil)
    @entry_station = entry_station
    @complete = false
    @fare = 0
  end

  def complete?
    @complete
  end

  def set_complete(station = nil)
    @complete = true
    set_exit_station(station)
    set_fare
  end

  def set_exit_station(station)
    @exit_station = station
  end

  private

  def set_fare
    if entry_station && exit_station
      @fare = MIN_FARE
    else
      @fare = PENALTY_FARE
    end
  end

end
