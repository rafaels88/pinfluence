class MomentRepository < Hanami::Repository
  relations :people

  associations do
    belongs_to :person
    has_many :locations
  end

  def all_with_influencers
    aggregate(:person)
      .map_to(Moment)
      .call.collection
  end

  def find_with_locations(id)
    aggregate(:locations)
      .where(moments__id: id)
      .map_to(Moment)
      .one
  end

  def add_location(moment, data)
    assoc(:locations, moment).add(data)
  end

  def search_by_date(params, limit: 100)
    conditional = Sequel.lit('year_begin <= ? AND (year_end >= ? OR year_end IS NULL)',
                             params[:year], params[:year])

    q = aggregate(:locations, :person).where(conditional)
    q = q.limit(limit) if limit
    q.map_to(Moment).call.collection
  end

  def all_available_years
    return [] if moments.count.zero?

    (min_year..max_year).to_a.map { |y| Values::Year.new y }
  end

  def search_by_influencer(influencer, limit: 100)
    q = aggregate(:person, :locations)
        .where("#{influencer.type}_id": influencer.id)
    q = q.limit(limit) if limit
    q.map_to(Moment).call.collection
  end

  def earliest_moment_of_an_influencer(influencer)
    q = moments.where("#{influencer.type}_id": influencer.id).order(:year_begin).limit(1)
    q.map_to(Moment).call.collection.first
  end

  private

  def min_year
    moments.min(:year_begin)
  end

  def max_year
    return Time.now.year if moments_happening_now.count.positive?

    moments.max(:year_end)
  end

  def moments_happening_now
    moments.where(year_end: nil)
  end
end
