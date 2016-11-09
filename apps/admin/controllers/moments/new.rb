module Admin::Controllers::Moments
  class New
    include Admin::Action
    expose :influencers

    def call(params)
      @influencers = ListAvailableInfluencers.call(repository: PersonRepository)
    end
  end
end
