module Admin::Controllers::People
  class Edit
    include Admin::Action
    expose :person

    def call(params)
      @person = PersonRepository.new.find(params[:id])
    end
  end
end
