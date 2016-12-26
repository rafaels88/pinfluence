Dir[Hanami.root.join('spec/support/factories/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    FactoryGirl.find_definitions
  end
end

FactoryGirl.define do
  to_create do |instance|
    repository = Object.const_get("#{instance.class}Repository").new
    repository.create(instance)
  end
end

module FactoryGirl
  module Strategy
    class Create
      attr_reader :evaluation

      def association(runner)
        runner.run
      end

      def result(evaluation)
        @evaluation = evaluation
        persisted = evaluation.create(instance)

        evaluation.notify(:after_build, instance)
        evaluation.notify(:before_create, instance)
        evaluation.notify(:after_create, persisted)
        persisted
      end

      private

      def instance
        evaluation.object
      end
    end
  end
end
