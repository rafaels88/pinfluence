module Admin::Controllers::People
  class Index
    include Admin::Action
    expose :people

    def call(params)
      @people = ListAvailableInfluencers.call(repository: PersonRepository.new)
    end
  end
end
