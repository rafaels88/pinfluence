FactoryGirl.define do
  factory :moment do
    year_begin 100
    year_end 180

    initialize_with { new(attributes) }
  end
end
