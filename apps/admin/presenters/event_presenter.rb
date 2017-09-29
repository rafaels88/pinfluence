class EventPresenter
  include Hanami::Presenter

  def moments
    result = if @object.id.nil?
               []
             else
               MomentRepository.new.search_by_influencer(@object)
             end
    result.push(Moment.new)
  end
end
