FactoryGirl.define do
  factory :moment do
    year_begin 100
    year_end 180
    person_id 1

    initialize_with { new(attributes) }
  end
end
