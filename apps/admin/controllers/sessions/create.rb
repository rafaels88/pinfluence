module Admin::Controllers::Sessions
  class Create
    include Admin::Action

    def call(_)
      user = FindUserByAuthCredentials.call(email: requested_email,
                                            password: requested_password)

      if !user.nil?
        session[:user_id] = user.id
        redirect_to routes.home_path
      else
        flash[:error] = 'Invalid email and/or password'
        redirect_to routes.new_session_path
      end
    end

    private

    def requested_email
      params[:session][:email]
    end

    def requested_password
      params[:session][:password_plain]
    end

    def authenticate!; end
  end
end
