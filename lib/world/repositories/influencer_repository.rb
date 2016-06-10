class InfluencerRepository
  include Hanami::Repository

  def by_date(opts)
    query do
      where("begin_at <= '#{opts[:year]}-01-01' AND end_at >= '#{opts[:year]}-12-31'")
    end
  end

  def all_available_years
    min_date = query.min(:begin_at)
    max_date = query.max(:end_at)
    (min_date.year..max_date.year).to_a
  end
end
