require_relative './interactor'

class DestroyMoment
  include Interactor

  attr_reader :moment_id, :repository

  def initialize(moment_id, repository: MomentRepository.new)
    @moment_id = moment_id
    @repository = repository
  end

  def call
    repository.delete(moment_id)
  end
end
