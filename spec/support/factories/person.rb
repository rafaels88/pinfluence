FactoryGirl.define do
  factory :person do
    name 'Socrates'
    gender 'male'

    initialize_with { new(attributes) }
  end
end
