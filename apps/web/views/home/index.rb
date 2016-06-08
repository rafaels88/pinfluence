module Web::Views::Home
  class Index
    include Web::View

    def coords
      influencers.map do |influencer|
        lat, lng = influencer.location.split(",")
        [lat.to_f, lng.to_f]
      end
    end
  end
end
