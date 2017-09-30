require_relative './interactor'

class DestroyEvent
  include Interactor

  attr_reader :event_id, :event_repository, :indexer_class, :opts

  def initialize(event_id, opts: {})
    @event_id = event_id
    @opts = opts
    @event_repository = opts[:event_repository] || EventRepository.new
    @indexer_class = opts[:indexer] || Influencers::Indexer
  end

  def call
    delete_event_moments!
    delete_index!
    event_repository.delete(event_id)
  end

  private

  def delete_event_moments!
    event.moments.each do |moment|
      DestroyMoment.call(moment.id, opts: opts)
    end
  end

  def delete_index!
    indexer_class.new(influencers: [event], index_object: Influencers::EventIndexObject).delete
  end

  def event
    @_event ||= event_repository.find_with_moments(event_id)
  end
end
