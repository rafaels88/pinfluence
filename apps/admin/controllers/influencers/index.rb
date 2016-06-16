module Admin::Controllers::Influencers
  class Index
    include Admin::Action

    expose :influencers

    def call(params)
      @influencers = InfluencerRepository.all
    end
  end
end
