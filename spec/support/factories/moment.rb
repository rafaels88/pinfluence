FactoryGirl.define do
  factory :moment do
    year_begin 100
    year_end 180
    influencer_id 1
    influencer_type "Person"

    initialize_with { new(attributes) }
  end
end
