module Web::Views::Home
  class Index
    include Web::View

    def moments_api_url
      Api::Routes.moments_path
    end

    def years_api_url
      Api::Routes.moment_years_path
    end
  end
end
