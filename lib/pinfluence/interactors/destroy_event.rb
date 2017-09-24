require_relative './interactor'

class DestroyEvent
  include Interactor

  attr_reader :event_id, :repository

  def initialize(event_id, repository: EventRepository.new)
    @event_id = event_id
    @repository = repository
  end

  def call
    delete_event_moments!
    repository.delete(event_id)
  end

  private

  def delete_event_moments!
    event.moments.each do |moment|
      DestroyMoment.call(moment.id)
    end
  end

  def event
    @_event ||= repository.find_with_moments(event_id)
  end
end
