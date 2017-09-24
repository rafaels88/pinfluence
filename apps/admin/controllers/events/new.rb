module Admin::Controllers::Events
  class New
    include Admin::Action
    expose :event

    def call(_)
      @event = EventPresenter.new(Event.new)
    end
  end
end
