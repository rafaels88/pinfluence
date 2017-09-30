require_relative './interactor'

class DestroyMoment
  include Interactor

  attr_reader :moment_id, :moment_repository, :opts

  def initialize(moment_id, opts: {})
    @moment_id = moment_id
    @moment_repository = opts[:moment_repository] || MomentRepository.new
    @opts = opts
  end

  def call
    @influencer_id = moment.influencer_id
    @influencer_type = moment.influencer_type

    moment_repository.delete(moment_id)
    updates_associated_influencer!
  end

  private

  def updates_associated_influencer!
    return unless @influencer_id
    Influencers::UpdateEarliestMoment.call influencer: influencer, opts: opts
  end

  def moment
    @_moment ||= moment_repository.find moment_id
  end

  def influencer
    Influencers::Find.call(id: @influencer_id, type: @influencer_type)
  end
end
