module Admin::Controllers::Influencers
  class Index
    include Admin::Action

    expose :influencers

    def call(params)
      @influencers = InfluencerRepository.new.all
    end
  end
end
