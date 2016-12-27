class MomentRepository < Hanami::Repository
  associations do
    has_many :locations
  end

  def add_location(moment, data)
    assoc(:locations, moment).add(data)
  end

  def search_by_date(params)
    moments
      .where("year_begin <= #{params[:year]}")
      .where("year_end >= #{params[:year]}")
      .as(Moment)
      .call
      .collection
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
      .where("#{influencer.type}_id": influencer.id)
      .as(Moment)
      .call.collection
  end

  private

  def all_still_ocurring
    moments.where(year_end: nil)
  end
end
