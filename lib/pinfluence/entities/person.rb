class Person < Hanami::Entity
  def moments
    moment_repository.search_by_influencer(self)
  end

  private

  def moment_repository
    MomentRepository.new
  end
end
