module Interactor
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def call(params)
      new(params).call
    end
  end
end
