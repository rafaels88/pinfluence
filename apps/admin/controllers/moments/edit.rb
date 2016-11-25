module Admin::Controllers::Moments
  class Edit
    include Admin::Action
    expose :influencers
    expose :moment

    def call(params)
      @influencers = ListAvailableInfluencers.call(repository: PersonRepository.new)
      @moment = MomentRepository.new.find(params[:id])
    end
  end
end
