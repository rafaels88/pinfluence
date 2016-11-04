class DestroyMoment
  def self.call(params)
    self.new(params).call
  end

  attr_reader :moment_id, :repository

  def initialize(moment_id, repository: MomentRepository)
    @moment_id = moment_id
    @repository = repository
  end

  def call
    repository.delete(moment)
  end

  private

  def moment
    repository.find(moment_id)
  end
end
