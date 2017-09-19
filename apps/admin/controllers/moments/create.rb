module Admin::Controllers::Moments
  class Create
    include Admin::Action
    expose :moment, :influencers

    def call(params)
      result = CreateMoment.call(moment_params(params))
      redirect_to routes.moments_path if result.success?

      prepare_for_editing(result)
      flash[:error] = result.errors.first
    end

    private

    def prepare_for_editing(result)
      @influencers = ListAvailableInfluencers.call(
        repository: PersonRepository.new
      )
      @moment = result.moment
    end

    def moment_params(params)
      # Need to transform :locations in an array until we have a
      # nice solution, since :fields_for helper does not work for collections

      @_moment_params = {}
      @_moment_params[:moment] = params[:moment].dup
      @_moment_params[:locations] = [params[:moment][:locations]]
      @_moment_params[:influencer] = params[:moment][:influencer]
      @_moment_params[:moment].delete(:id)
      @_moment_params
    end
  end
end
