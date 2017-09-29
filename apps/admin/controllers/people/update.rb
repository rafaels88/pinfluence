module Admin::Controllers::People
  class Update
    include Admin::Action

    def call(params)
      UpdatePerson.call(person_params(params))
      redirect_to routes.edit_person_path(id: params[:id])
    end

    private

    def person_params(params)
      Hanami::Utils::Hash.deep_symbolize(
        person: params[:person].merge(id: params[:id])
      )
    end
  end
end
