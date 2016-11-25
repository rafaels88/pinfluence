module Admin
  module Authentication
    def self.included(action)
      action.class_eval do
        before :authenticate!
        expose :current_user
      end
    end

    private

    def authenticate!
      redirect_to routes.new_session_path unless authenticated?
    end

    def authenticated?
      !!current_user
    end

    def current_user
      @current_user ||= UserRepository.new.find(session[:user_id])
    end
  end
end
