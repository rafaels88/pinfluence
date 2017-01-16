module Interactors
  class Result
    attr_reader :errors

    def initialize(failed: false, errors: [], exposed: [])
      @errors = errors
      @failed = failed

      expose_attrs(exposed)
    end

    def failure?
      @failed || errors.count > 0
    end

    def success?
      !failure?
    end

    private

    def expose_attrs(attrs)
      attrs.each do |attr|
        attr_name, value = attr.to_a.first
        instance_variable_set("@#{attr_name}", value)
        singleton_class.class_eval { attr_reader attr_name }
      end
    end
  end
end
