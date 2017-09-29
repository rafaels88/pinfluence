module Admin::Controllers::People
  class Index
    include Admin::Action
    expose :people

    def call(_)
      @people = Influencers::ListAvailableInfluencers.call(repository: PersonRepository.new)
    end
  end
end
