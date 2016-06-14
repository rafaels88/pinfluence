module Admin::Controllers::Sessions
  class Create
    include Admin::Action

    params :session do
      param :email, presence: true
      param :password_plain, presence: true
    end

    def call(params)
      user = UserRepository.new.find_by(email: params[:session][:email])
      if user
        
      end
    end

    private

    def authenticate!; end
  end
end
