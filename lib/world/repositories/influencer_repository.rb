class InfluencerRepository
  include Hanami::Repository

  def by_date(opts)
    query do
      where("begin_at <= #{opts[:year]}").and("end_at >= #{opts[:year]}")
    end
  end

  def by_name(name)
    query do
      where("lower(name) = '#{name.downcase}'")
    end.first
  end

  def all_available_years
    min_year = query.min(:begin_at)
    max_year = query.max(:end_at)
    (min_year..max_year).to_a
  end
end
