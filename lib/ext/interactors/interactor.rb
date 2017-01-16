module Interactors
  module Interactor
    def self.included(base)
      base.prepend Interface
      base.extend ClassMethods
    end
  end

  module ClassMethods
    def call(params)
      new(params).call
    end

    def expose(attr)
      class_variable_set(:@@exposed_attrs, []) unless exposed_attrs
      exposed_attrs.push(attr)
    end

    def exposed_attrs
      class_variable_get(:@@exposed_attrs)
    rescue
      nil
    end
  end

  module Interface
    def add_error(params)
      @errors = [] unless @errors
      @errors.push(params)
    end

    def fail!
      @failed = true
    end

    def call
      super
      Result.new(failed: @failed, errors: @errors || [], exposed: exposed || [])
    end

    private

    def exposed
      if self.class.exposed_attrs
        self.class.exposed_attrs.map do |attr|
          { attr.to_s => instance_variable_get("@#{attr}").dup }
        end
      end
    end
  end
end
