module Interactor
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def call(*params, **kw)
      new(*params, **kw).call
    end
  end
end
