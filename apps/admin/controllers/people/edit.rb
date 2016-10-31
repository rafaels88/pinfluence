module Admin::Controllers::People
  class Edit
    include Admin::Action
    expose :person

    def call(params)
      @person = PersonRepository.find(params[:id])
    end
  end
end
