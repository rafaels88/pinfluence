module Admin::Controllers::People
  class Create
    include Admin::Action

    def call(params)
      CreatePerson.call(params[:person])
      redirect_to routes.people_path
    end
  end
end
