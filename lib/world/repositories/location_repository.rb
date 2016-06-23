class LocationRepository
  include Hanami::Repository

  def self.by_date(opts)
    query do
      where("begin_in <= #{opts[:year]}").and("end_in >= #{opts[:year]}")
    end
  end

  def self.by_latlng(lat:, lng:)
    query do
      where(latlng: "#{lat}, #{lng}")
    end
  end

  def self.all_available_years
    min_year = query.min(:begin_in)
    max_year = query.max(:end_in) || Time.now.year
    (min_year..max_year).to_a
  end

  def self.first_location_of_influencer(influencer)
    query do
      where(influencer_id: influencer.id).order(:begin_in).limit(1)
    end.first
  end

  def self.by_influencer(influencer)
    query do
      where(influencer_id: influencer.id)
    end
  end
end
