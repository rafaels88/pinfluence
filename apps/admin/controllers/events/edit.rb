module Admin::Controllers::Events
  class Edit
    include Admin::Action
    expose :event

    def call(params)
      event = EventRepository.new.find(params[:id])
      @event = InfluencerPresenter.new event
    end
  end
end
