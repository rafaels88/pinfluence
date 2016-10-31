class Event
  include Hanami::Entity
  attributes :name, :kind, :created_at, :updated_at
end
