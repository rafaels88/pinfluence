FactoryGirl.define do
  factory :user do
    name "Rafael Soares"
    email "rafael@email.com"
    password "123"

    initialize_with { new(attributes) }
  end
end
