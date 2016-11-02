module Admin::Controllers::Moments
  class New
    include Admin::Action
    expose :influencers

    def call(params)
      @influencers = influencers
    end

    private

    def influencers
      PersonRepository.all
    end
  end
end
