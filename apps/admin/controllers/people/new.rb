module Admin::Controllers::People
  class New
    include Admin::Action
    expose :person

    def call(_)
      @person = InfluencerPresenter.new(Person.new)
    end
  end
end
