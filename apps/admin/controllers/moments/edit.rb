module Admin::Controllers::Moments
  class Edit
    include Admin::Action
    expose :influencers
    expose :moment

    def call(params)
      @influencers = Influencers::ListAvailableInfluencers.call(repository: PersonRepository.new)
      @moment = MomentRepository.new.find_with_locations(params[:id])
    end
  end
end
