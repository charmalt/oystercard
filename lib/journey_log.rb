class Journeylog

  def initialize(journey_class: Journey)
    @journey_class = journey_class
    @journeys = []
  end

  def start(station = nil)
    @journey.set_complete if in_journey?
    create_journey(station)
  end

  def finish(station = nil)
    if !in_journey?
      create_journey(station)
      @journey.set_complete(station)
    end
    @journey.set_complete(station) if in_journey?
  end

  def in_journey?
    !!@journey && !@journey.complete?
  end

  def fare
    @journey.fare
  end

  def journeys
    @journeys
  end

  private

  def current_journey
    journeys.last.complete? ? create_journey : journeys.last
  end

  def create_journey(station)
    @journey = @journey_class.new(station)
    save(@journey)
  end

  def save(journey)
    journeys << @journey
  end

end
