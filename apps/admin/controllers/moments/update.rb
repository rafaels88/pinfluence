module Admin::Controllers::Moments
  class Update
    include Admin::Action

    def call(params)
      UpdateMoment.call(moment_params(params))
    rescue StandardError => e
      flash[:error] = e.message
    ensure
      redirect_to routes.edit_moment_path(id: params[:id])
    end

    private

    def moment_params(params)
      # Need to transform :locations in an array until we have a
      # nice solution, since :fields_for helper does not work for collections

      params = remove_person_id_if_new_person_given(params)

      Hanami::Utils::Hash.deep_symbolize(
        locations: [params[:moment].delete(:locations)],
        influencer: params[:moment].delete(:influencer),
        moment: params[:moment]
      )
    end

    def remove_person_id_if_new_person_given(params)
      unless params[:moment][:influencer][:name].to_s.empty?
        params[:moment][:influencer].delete(:id)
      end
      params
    end
  end
end
