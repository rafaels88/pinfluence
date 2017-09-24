FactoryGirl.define do
  factory :event do
    name 'Second World War'

    initialize_with { new(attributes) }
  end
end
