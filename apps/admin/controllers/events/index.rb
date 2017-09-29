module Admin::Controllers::Events
  class Index
    include Admin::Action
    expose :events

    def call(_)
      @events = Influencers::ListAvailableInfluencers.call(repository: EventRepository.new)
    end
  end
end
