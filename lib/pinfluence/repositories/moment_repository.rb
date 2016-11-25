class MomentRepository < Hanami::Repository

  def search_by_date(params)
    moments
      .where("year_begin <= #{params[:year]}")
        .where("year_end >= #{params[:year]}")
  end

  def all_available_years
    min_year = moments.min(:year_begin)
    max_year = moments.max(:year_end) || Time.now.year
    (min_year..max_year).to_a
  end

  def search_by_influencer(influencer)
    moments
      .where(influencer_id: influencer.id.to_s)
          .and(influencer_type: influencer.class.to_s)
  end
end
