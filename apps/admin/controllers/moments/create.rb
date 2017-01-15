module Admin::Controllers::Moments
  class Create
    include Admin::Action
    expose :moment, :influencers

    def call(_)
      result = CreateMoment.call(moment_params)
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

    def moment_params
      # Need to transform :locations in an array until we have a
      # nice solution, since :fields_for helper does not work for collections

      @_moment_params = params[:moment].dup
      @_moment_params[:locations] = [params[:moment][:locations]]
      @_moment_params.delete(:id)
      @_moment_params
    end
  end
end
