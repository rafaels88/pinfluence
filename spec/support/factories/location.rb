FactoryGirl.define do
  factory :location do
    address '4, Privet Drive, Little Whinging, Surrey, England'
    latlng '0,0'
    density 1
    moment

    initialize_with { new(attributes) }
  end
end
