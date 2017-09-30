class InfluencerPresenter
  include Hanami::Presenter

  def moments
    result = if @object.id.nil?
               []
             else
               all_by_influencer
             end
    result.push(MomentPresenter.new(Moment.new))
  end

  private

  def all_by_influencer
    MomentRepository.new.search_by_influencer(@object).map do |moment|
      MomentPresenter.new moment
    end
  end
end
