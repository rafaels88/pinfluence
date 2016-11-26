class MomentRepository < Hanami::Repository

  def search_by_date(params)
    moments
      .where("year_begin <= #{params[:year]}")
        .where("year_end >= #{params[:year]}")
  end

  def all_available_years
    return [] if moments.count == 0

    min_year = moments.min(:year_begin)
    if all_still_ocurring.count > 0
      max_year = Time.now.year
    else
      max_year = moments.max(:year_end)
    end
    (min_year..max_year).to_a
  end

  def search_by_influencer(influencer)
    moments
      .where(influencer_id: influencer.id.to_s)
          .and(influencer_type: influencer.class.to_s)
  end

  private

  def all_still_ocurring
    moments.where(year_end: nil)
  end
end
