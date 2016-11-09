module Admin::Controllers::Moments
  class Update
    include Admin::Action

    def call(params)
      UpdateMoment.call(moment_params(params))
      redirect_to routes.edit_moment_path(id: params[:id])
    end

    private

    def moment_params(params)
      # Need to transform :locations in an array until we have a
      # nice solution, since :fields_for helper does not work for collections

      @_moment_params = params[:moment].update({ id: params[:id] })
      @_moment_params[:locations] = [params[:moment][:locations]]
      @_moment_params
    end
  end
end
