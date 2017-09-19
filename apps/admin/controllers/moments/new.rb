module Admin::Controllers::Moments
  class New
    include Admin::Action
    expose :influencers

    def call(_)
      @influencers = ListAvailableInfluencers.call(repository: PersonRepository.new)
    end
  end
end
