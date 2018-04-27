describe Journeylog do

  subject(:journey_log) { described_class.new(journey_class: journey_class) }
  let(:station) { double :station }
  let(:journey_class) { double :journey_class, new: journey }
  let(:journey) { double :journey }

  describe '#initialize' do

    it 'returns journeys as an empty array' do
      expect(journey_log.journeys).to eq []
    end

  end

  describe '#start' do

    # before { allow(journey_class).to receive(:new).with(station).and_return(journey) }

    context 'no journey created' do

      it 'creates a new journey' do
        journey_log.start(station)
        expect(journey_log.journeys).to eq [journey]
      end

    end

    context 'previous journey not completed' do

      it 'completes previous journey' do
        journey_log.start(station)
        expect(journey).to receive(:set_complete).once
        allow(journey).to receive(:complete?).and_return(false)
        journey_log.start(station)
      end

      it 'creates new journey' do
        journey_log.start(station)
        expect(journey).to receive(:set_complete).once
        allow(journey).to receive(:complete?).and_return(false)
        journey_log.start(station)
        expect(journey_log.journeys).to eq [journey, journey]
      end

    end

  end

  describe '#finish' do

    context 'previous journey not completed' do

      it 'completes journey' do
        expect(journey).to receive(:set_complete).once
        journey_log.start(station)
        allow(journey).to receive(:complete?).and_return(false)
        journey_log.finish(station)
      end

    end

    context 'no current journey' do

      it 'creates and completes journey' do
        allow(journey_log).to receive(:in_journey?).and_return(false)
        expect(journey).to receive(:set_complete)
        journey_log.finish(station)
      end

    end

  end

end
