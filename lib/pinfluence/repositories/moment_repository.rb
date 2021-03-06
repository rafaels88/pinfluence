class MomentRepository < Hanami::Repository
  INFLUENCER_TYPES = %i[event person].freeze

  relations :people
  relations :events

  associations do
    belongs_to :person
    belongs_to :event
    has_many :locations
  end

  def add_location(moment, data)
    assoc(:locations, moment).add(data)
  end

  def first_ordered_by_date_begin(direction = :asc)
    moments.order { date_begin.send(direction) }.limit(1).map_to(Moment).one
  end

  def all_with_influencers
    INFLUENCER_TYPES.map do |influencer_type|
      aggregate(influencer_type)
        .where("#{influencer_type}_id IS NOT NULL")
        .map_to(Moment).call.collection
    end.flatten
  end

  def find_with_locations(id)
    aggregate(:locations)
      .where(moments__id: id)
      .map_to(Moment)
      .one
  end

  def search_by_date(params, limit: 100)
    INFLUENCER_TYPES.map do |influencer_type|
      conditional = Sequel.lit(
        "date_begin <= ? AND (date_end >= ? OR date_end IS NULL) AND #{influencer_type}_id IS NOT NULL",
        postgres_bc_date_transform(params[:date]), postgres_bc_date_transform(params[:date])
      )

      query = aggregate(:locations, influencer_type).where(conditional)
      query = query.limit(limit) if limit
      query.map_to(Moment).call.collection
    end.flatten
  end

  def search_by_influencer(influencer, limit: 100, order: :date_begin)
    q = aggregate(influencer.type, :locations).where("#{influencer.type}_id": influencer.id)
    q = q.order(order)
    q = q.limit(limit) if limit
    q.map_to(Moment).call.collection
  end

  def earliest_moment_of_an_influencer(influencer)
    q = moments.where("#{influencer.type}_id": influencer.id).order(:date_begin).limit(1)
    q.map_to(Moment).call.collection.first
  end

  private

  def postgres_bc_date_transform(date_value)
    return date_value unless date_value[0] == '-'
    "#{date_value[1..-1]} BC"
  end
end
