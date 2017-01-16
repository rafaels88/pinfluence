require_relative '../../ext/interactors/interactor'

module Interactor
  def self.included(base)
    base.include(Interactors::Interactor)
  end
end
