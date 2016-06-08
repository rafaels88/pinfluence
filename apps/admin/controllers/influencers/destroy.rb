module Admin::Controllers::Influencers
  class Destroy
    include Admin::Action

    def call(params)
      influencer = repository.find(params[:id])
      repository.delete(influencer)

      redirect_to routes.influencers_path
    end

    private

    def repository
      InfluencerRepository.new
    end
  end
end
