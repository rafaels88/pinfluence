module Admin::Controllers::Influencers
  class Create
    include Admin::Action

    def call(params)
      influencer = Influencer.new(params[:influencer])
      repository.create(influencer)

      redirect_to routes.influencers_path
    end

    private

    def repository
      InfluencerRepository.new
    end
  end
end
