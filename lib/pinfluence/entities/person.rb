class Person
  include Hanami::Entity
  attributes :name, :gender, :created_at, :updated_at

  def moments
    moment_repository.by_influencer(self)
  end

  private

  def moment_repository
    MomentRepository
  end
end
