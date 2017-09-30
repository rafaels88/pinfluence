module Admin::Controllers::Events
  class New
    include Admin::Action
    expose :event

    def call(_)
      @event = InfluencerPresenter.new(Event.new)
    end
  end
end
