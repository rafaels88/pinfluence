FactoryGirl.define do
  factory :user do
    name 'Rafael Soares'
    email 'rafael@email.com'
    password '123'

    after(:create) do |u|
      UserRepository.new.update(u.id, password: BCrypt::Password.create(u.password))
    end

    initialize_with { new(attributes) }
  end
end
