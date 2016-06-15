class User
  include Hanami::Entity

  attributes :name, :email, :password, :created_at, :updated_at
end
