module Web::Controllers::Home
  class Index
    include Web::Action

    expose :influencers

    def call(params)
      @influencers = repository.all
    end

    private

    def repository
      InfluencerRepository.new
    end
  end
end
