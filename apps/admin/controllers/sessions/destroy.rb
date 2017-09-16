module Admin::Controllers::Sessions
  class Destroy
    include Admin::Action

    def call(_)
      session[:user_id] = nil
      redirect_to routes.new_session_path
    end
  end
end
