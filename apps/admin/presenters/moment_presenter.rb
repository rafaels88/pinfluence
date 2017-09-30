class MomentPresenter
  include Hanami::Presenter

  def locations
    return [Location.new] if @object.id.nil?
    LocationRepository.new.by_moment(@object)
  end
end
