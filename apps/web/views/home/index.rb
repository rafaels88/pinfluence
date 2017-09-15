module Web::Views::Home
  class Index
    include Web::View

    def gmaps_tag
      raw "<script src='https://maps.googleapis.com/maps/api/js" \
        "?key=#{ENV['GOOGLE_MAPS_API_KEY']}&libraries=visualization'></script>"
    end

    def api_url
      Api::routes.root_path
    end
  end
end
