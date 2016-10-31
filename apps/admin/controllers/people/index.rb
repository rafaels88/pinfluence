module Admin::Controllers::People
  class Index
    include Admin::Action
    expose :people

    def call(params)
      @people = AvailablePeople.call
    end
  end
end
