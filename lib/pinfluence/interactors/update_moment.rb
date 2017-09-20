require_relative './interactor'

class UpdateMoment
  include Interactor

  attr_reader :id, :locations, :year_begin, :year_end, :repository

  def initialize(moment:, influencer:, locations:, opts: {})
    @year_begin = moment[:year_begin]
    @year_end = moment[:year_end].to_s.empty? ? nil : moment[:year_end]
    @id = moment[:id]
    @locations = locations
    @influencer = influencer
    @opts = opts

    @repository = opts.fetch(:repository, MomentRepository.new)
  end

  def call
    create_influencer_if_new!
    repository.update(id, persist_params)
    persist_locations!
  end

  private

  def create_influencer_if_new!
    return unless new_influencer? && person?

    person = CreatePerson.call(name: influencer[:name], gender: influencer[:gender],
                               opts: { indexer: @opts[:influencer_indexer] })
    @influencer[:id] = person.id
  end

  def persist_locations!
    Moments::PersistLocations.call(moment: moment, locations: locations, opts: @opts)
  end

  def new_influencer?
    influencer[:id].empty?
  end

  def person?
    influencer[:type] == :person
  end

  def moment
    @_moment ||= repository.find(id)
  end

  def influencer
    @influencer[:type] = @influencer[:type].to_sym
    @influencer[:id] = @influencer[:id].to_s
    @influencer
  end

  def persist_params
    {
      year_begin: year_begin,
      year_end: year_end,
      person_id: influencer[:id]
    }
  end
end
