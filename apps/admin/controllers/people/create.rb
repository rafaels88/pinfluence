module Admin::Controllers::People
  class Create
    include Admin::Action

    def call(params)
      person = CreatePerson.call(person_params(params))
      redirect_to routes.edit_person_path(id: person.id)
    rescue StandardError => e
      flash[:error] = e.message
      redirect_to routes.new_person_path
    end

    private

    def person_params(params)
      Hanami::Utils::Hash.deep_symbolize(
        moments: params[:person].delete(:moments),
        person: params[:person].merge(id: params[:id])
      )
    end
  end
end
