class EventRepository < Hanami::Repository
  associations do
    has_many :moments
  end

  def find_with_moments(id)
    aggregate(:moments)
      .where(events__id: id)
      .map_to(Event)
      .one
  end

  def all_ordered_by(field)
    events
      .order(field)
      .map_to(Event)
      .call.collection
  end
end
