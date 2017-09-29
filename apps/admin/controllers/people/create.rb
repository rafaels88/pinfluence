module Admin::Controllers::People
  class Create
    include Admin::Action

    def call(params)
      CreatePerson.call(person_params(params))
      redirect_to routes.people_path
    end

    private

    def person_params(params)
      Hanami::Utils::Hash.deep_symbolize(
        person: params[:person].merge(id: params[:id])
      )
    end
  end
end
