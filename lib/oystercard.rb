# require_relative './journey'
# require_relative './station'
# require_relative './journey_log'

class Oystercard

  DEFAULT_BALANCE = 0
  MAX_BALANCE = 90
  MIN_BALANCE = 1

  attr_reader :balance, :entry_station, :journey_log, :journeys

  def initialize(balance: DEFAULT_BALANCE, journey_log: Journeylog.new)
    @balance = balance
    @journey_log = journey_log
  end

  def top_up(money)
    fail "Maximum balance of #{MAX_BALANCE} exceeded" if (@balance + money) > MAX_BALANCE
    @balance += money
  end

  def in_journey?
    @journey_log.in_journey?
  end

  def touch_in(entry_station)
    fail "Minimum balance of #{MIN_BALANCE} required" if @balance < MIN_BALANCE
    @journey_log.start(entry_station)
    deduct(get_fare)
  end

  def touch_out(exit_station)
    @journey_log.finish(exit_station)
    deduct(get_fare)
  end

  def journeys
    @journeys = journey_log.journeys
  end

  private

  def deduct(money)
    @balance -= money
  end

  def get_fare
    @journey_log.fare
  end

end
