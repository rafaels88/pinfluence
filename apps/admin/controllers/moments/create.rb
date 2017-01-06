module Admin::Controllers::Moments
  class Create
    include Admin::Action
    attr_reader :params

    def call(params)
      @params = params
      CreateMoment.call(moment_params)
      redirect_to routes.moments_path
    end

    private

    def moment_params
      # Need to transform :locations in an array until we have a
      # nice solution, since :fields_for helper does not work for collections

      @_moment_params = params[:moment]
      @_moment_params[:locations] = [params[:moment][:locations]]
      @_moment_params.delete(:id)
      @_moment_params
    end
  end
end
