require_relative '../../lib/ext/interactors/interactor'
require_relative '../../lib/ext/interactors/result'

class NoopInteractor
  include Interactors::Interactor
  def call; end
end

class FailerInteractor
  include Interactors::Interactor
  def call
    fail!
  end
end

class ErroredInteractor
  include Interactors::Interactor
  def call
    add_error(field: 'Error message')
  end
end

class SuccessInteractor
  include Interactors::Interactor
  def call; end
end

class ExposerInteractor
  include Interactors::Interactor
  expose :exposed

  def initialize(exposed_value)
    @exposed = exposed_value
    @non_exposed = 'NON EXPOSED'
  end

  def call; end
end
