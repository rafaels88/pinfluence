module Admin::Controllers::People
  class Destroy
    include Admin::Action

    def call(params)
      DestroyPerson.call(params[:id])
      redirect_to routes.people_path
    end
  end
end
