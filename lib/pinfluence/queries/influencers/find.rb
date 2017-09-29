require_relative '../../interactors/interactor'

module Influencers
  class Find
    include Interactor

    attr_reader :id, :type

    def initialize(id:, type:)
      @id = id
      @type = type
    end

    def call
      repository.find id
    end

    private

    def repository
      repo_klass.new
    end

    def repo_klass
      "#{type}_repository".camelize.constantize
    end
  end
end
