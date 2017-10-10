FactoryGirl.define do
  factory :moment do
    date_begin Date.today
    date_end Date.today

    initialize_with { new(attributes) }
  end
end
