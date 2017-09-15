module Web::Views::Home
  class Index
    include Web::View

    def gmaps_tag
      raw "<script src='https://maps.googleapis.com/maps/api/js" \
        "?key=#{ENV['GOOGLE_MAPS_API_KEY']}&libraries=visualization'></script>"
    end

    def moments_api_url
      Api::routes.moments_path
    end

    def years_api_url
      Api::routes.moment_years_path
    end

    def api_graphql_url
      ApiGraphql::routes.root_path
    end
  end
end
