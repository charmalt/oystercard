feature 'Oystercard Challenge', :feature do

  let(:oystercard) { Oystercard.new }
  let(:entry_station) { Station.new('Oxford Circus', 1) }
  let(:exit_station) { Station.new('Oxford Circus', 1) }

  let(:min_fare) { Journey::MIN_FARE }
  let(:max_balance) { Oystercard::MAX_BALANCE}
  let(:default_balance) { Oystercard::DEFAULT_BALANCE }

  before do
    oystercard.top_up(10)
  end

  context 'with valid journey' do
    before do
      oystercard.touch_in(entry_station)
    end

    scenario 'creating a journey on touch in' do
      expect(oystercard).to be_in_journey
    end

    scenario 'completes a valid journey on touch out' do
      oystercard.touch_out(exit_station)
      expect(oystercard).not_to be_in_journey
      oystercard.journey_log.journeys
      expect(oystercard.journey_log.journeys.last.entry_station).to be entry_station
      expect(oystercard.journey_log.journeys.last.exit_station).to be exit_station
    end

    scenario 'deducts fare given valid journey' do
      expect{ oystercard.touch_out(exit_station) }.to change{ oystercard.balance }.by(-min_fare)
    end


  end

  #Penalty fares
  context 'incomplete journey - no touch out' do

    let(:entry_station2) { Station.new('Clapham', 2) }
    before do
      oystercard.touch_in(entry_station)
    end

    scenario 'touch in again' do
      oystercard.touch_in(entry_station2)
      expect(oystercard).to be_in_journey
      expect(oystercard.journey_log.journeys.count).to eq 2
      expect(oystercard.journey_log.journeys.last.entry_station).to be entry_station2
      expect(oystercard.journey_log.journeys[-2]).to be_complete
    end

  end

  context 'incomplete journey no touch in' do

    let(:exit_station2) { Station.new('Notting Hill gate', 1) }

    scenario 'First use is a touch out' do
      oystercard.touch_out(exit_station2)
      expect(oystercard.journey_log.journeys.count).to eq 1
      expect(oystercard.journey_log.journeys.last).to be_complete
      expect(oystercard.journey_log.journeys.last.exit_station).to be exit_station2
    end

    scenario 'after a touch out' do
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      oystercard.touch_out(exit_station2)
      expect(oystercard.journey_log.journeys.count).to eq 2
      expect(oystercard.journey_log.journeys.last).to be_complete
      expect(oystercard.journey_log.journeys.last.exit_station).to be exit_station2
    end

  end

end
