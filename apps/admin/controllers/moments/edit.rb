module Admin::Controllers::Moments
  class Edit
    include Admin::Action
    expose :influencers
    expose :moment

    def call(params)
      @influencers = ListAvailableInfluencers.call(repository: PersonRepository)
      @moment = MomentRepository.find(params[:id])
    end
  end
end
