module Admin::Controllers::Sessions
  class Create
    include Admin::Action

    def call(params)
      user = UserRepository.find_by_email(email: params[:session]["email"])

      if user && user.password == params[:session]["password_plain"]
        session[:user_id] = user.id
        redirect_to routes.influencers_path
      else
        redirect_to routes.new_session_path
      end
    end

    private

    def authenticate!; end
  end
end
