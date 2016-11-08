class MomentRepository
  include Hanami::Repository

  def self.search_by_date(params)
    query do
      where("year_begin <= #{params[:year]}").and("year_end >= #{params[:year]}")
    end
  end

  def self.all_available_years
    min_year = query.min(:year_begin)
    max_year = query.max(:year_end) || Time.now.year
    (min_year..max_year).to_a
  end

  def self.search_by_influencer(influencer)
    query do
      where(influencer_id: influencer.id.to_s)
        .and(influencer_type: influencer.class.to_s)
    end.all
  end
end
