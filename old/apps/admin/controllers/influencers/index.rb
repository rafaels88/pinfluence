module Admin::Controllers::Influencers
  class Index
    include Admin::Action

    expose :influencers

    def call(params)
      @influencers = InfluencerRepository.all_ordered_by(:name)
    end
  end
end
