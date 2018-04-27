describe Oystercard do
  
  let(:fare) { 1 }
  let(:penalty_fare) { 6 }
  let(:max_balance) { Oystercard::MAX_BALANCE}
  let(:default_balance) { Oystercard::DEFAULT_BALANCE }
  let(:min_balance) { Oystercard::MIN_BALANCE }

  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }

  subject(:card) {described_class.new(journey_log: journey_log)}
  let(:journey_log) { double :journey_log }

  describe '#top_up' do

    it 'tops up' do
      card.top_up(5)
      expect(card.balance).to eq 5
    end

    it 'raises error if top up exceeds maximum balance' do
      expect { card.top_up(91) }.to raise_error "Maximum balance of #{max_balance} exceeded"
    end

  end

  describe '#initialize' do

    before {allow(journey_log).to receive(:in_journey?).and_return(false)}
    before {allow(journey_log).to receive(:journeys).and_return([])}

    it 'sets a default balance to 0' do
      expect(card.balance).to eq default_balance
    end

    it 'sets default in_journey status to false' do
      expect(card.in_journey?).to be false
    end

    it 'sets default journey history to empty' do
      expect(card.journeys).to eq []
    end

  end

  describe '#touch_in' do

    it 'touches in' do
      expect(journey_log).to receive(:start)
      expect(journey_log).to receive(:fare).and_return(0)
      allow(journey_log).to receive(:in_journey?).and_return(true)
      card.top_up(5)
      card.touch_in(entry_station)
      expect(card).to be_in_journey
    end

    it 'raises error if balance is below minimum limit' do
      expect { card.touch_in(entry_station) }.to raise_error "Minimum balance of #{min_balance} required"
    end

    context 'after touch in' do

      before do
        card.top_up(5)
        expect(journey_log).to receive(:start).twice
        allow(journey_log).to receive(:fare).and_return(0)
        card.touch_in(entry_station)
      end

      it 'completes journey with penalty fare' do
        allow(journey_log).to receive(:fare).and_return(penalty_fare)
        expect{ card.touch_in(entry_station) }.to change{ card.balance }.by(-penalty_fare)
      end

      it 'deducts penalty fare' do
        card.touch_in(entry_station)
        allow(journey_log).to receive(:in_journey?).and_return(false)
        expect(card).to_not be_in_journey
      end

    end

  end

  describe '#touch_out' do

    context 'after touch in' do

      before do
        card.top_up(5)
        expect(journey_log).to receive(:start).once
        expect(journey_log).to receive(:fare).twice
        expect(journey_log).to receive(:finish)
        allow(journey_log).to receive(:fare).and_return(0)
        card.touch_in(entry_station)
      end

      it 'completes journey' do
        allow(journey_log).to receive(:in_journey?).and_return(false)
        card.touch_out(exit_station)
        expect(card).to_not be_in_journey
      end

      it 'charges money' do
        allow(journey_log).to receive(:fare).and_return(fare)
        expect { card.touch_out(exit_station) }.to change { card.balance }.by(-fare)
      end

    end

    context 'after touch out' do

      before do
        card.top_up(5)
        expect(journey_log).to receive(:start).once
        expect(journey_log).to receive(:finish).twice
        allow(journey_log).to receive(:in_journey?).and_return(false)
        allow(journey_log).to receive(:fare).and_return(1)
        card.touch_in(entry_station)
        card.touch_out(exit_station)
      end

      it 'saves journey' do
        allow(journey_log).to receive(:in_journey?).and_return(false)
        card.touch_out(exit_station)
      end

      it 'deducts money' do
        allow(journey_log).to receive(:fare).and_return(penalty_fare)
        expect{card.touch_out(exit_station)}.to change{card.balance}.by(-penalty_fare)
      end

    end

  end

end
