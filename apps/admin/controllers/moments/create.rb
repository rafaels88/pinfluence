module Admin::Controllers::Moments
  class Create
    include Admin::Action
    expose :moment, :influencers

    def call(params)
      moment = CreateMoment.call(moment_params(params))
      redirect_to routes.edit_moment_path(id: moment.id)
    rescue StandardError => e
      flash[:error] = e.message
      redirect_to routes.new_moment_path
    end

    private

    def moment_params(params)
      # Need to transform :locations in an array until we have a
      # nice solution, since :fields_for helper does not work for collections

      Hanami::Utils::Hash.deep_symbolize(
        locations: [params[:moment].delete(:locations)],
        influencer: params[:moment].delete(:influencer),
        moment: params[:moment]
      )
    end
  end
end
