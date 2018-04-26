# irb -r './spec/feature_tests.rb'

require './lib/oystercard'
require './lib/station'
require './lib/journey'

oystercard = Oystercard.new
entry_station = Station.new('Oxford Circus', 1)
exit_station = Station.new('Oxford Circus', 1)
oystercard.top_up(10)
oystercard.touch_in(entry_station)
oystercard.touch_out(exit_station)
oystercard.in_journey?
p oystercard.journey_log

=begin
def set_balance
  card = Oystercard.new
  p card
end

def top_up
  card = Oystercard.new
  card.top_up(5)
  p card
end

def max_balance
  card = Oystercard.new
  card.top_up(91)
  p card
end

def check_status
  card = Oystercard.new
  p card
end

def min_amount
  card = Oystercard.new
  card.touch_in('station')
  p card
end

def deduct_money_touch_out
  card = Oystercard.new
  card.top_up(10)
  card.touch_in('station')
  card.touch_out('station2')
  p card
end

def entry_station
  card = Oystercard.new
  card.top_up(10)
  card.touch_in('station')
  p card
end

def entry_station_touch_out
  card = Oystercard.new
  card.top_up(10)
  card.touch_in('station')
  card.touch_out('station2')
  p card
end

def default_journey_history
  card = Oystercard.new
  card.top_up(10)
  p card
end

# hash with entry and exit station
def store_journey
  card = Oystercard.new
  card.top_up(10)
  card.touch_in('station')
  card.touch_out('station2')
  p card
end

set_balance
top_up
# max_balance
check_status
# min_amount
deduct_money_touch_out
entry_station
entry_station_touch_out
default_journey_history
store_journey

def create_station
  name = 'Stratford'
  zone = 3
  p Station.new(name, zone)
end

create_station

def create_journey
  p Journey.new
  # get complete? and fare
end

# create new class Journey - start, finish, fare, complete?
# fare method - penalty(6)/ minimum
=end
