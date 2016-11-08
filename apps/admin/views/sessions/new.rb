module Admin::Views::Sessions
  class New
    include Admin::View
    layout :auth

    def form
      Form.new(:session, routes.sessions_path)
    end

    def submit_label
      'Sign in'
    end
  end
end
