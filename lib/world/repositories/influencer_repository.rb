class InfluencerRepository
  include Hanami::Repository

  def self.by_date(opts)
    query do
      where("begin_at <= #{opts[:year]}").and("end_at >= #{opts[:year]}")
    end
  end

  def self.by_name(name)
    query do
      where("lower(name) = '#{name.downcase}'")
    end.first
  end

  def self.by_latlng(lat:, lng:)
    query do
      where(latlng: "#{lat}, #{lng}")
    end
  end

  def self.all_available_years
    min_year = query.min(:begin_at)
    max_year = query.max(:end_at)
    (min_year..max_year).to_a
  end

  def self.all_ordered_by(field=:name)
    query do
      order(field)
    end
  end
end
