require 'hanami/model'
require 'hanami/mailer'
Dir["#{__dir__}/pinfluence/**/*.rb"].each { |file| require_relative file }

Hanami::Model.configure do
  adapter type: :sql, uri: ENV['DATABASE_URL']

  mapping do
    collection :locations do
      entity     Location
      repository LocationRepository

      attribute :id,   Integer
      attribute :address, String
      attribute :latlng, String
      attribute :density, Integer
      attribute :moment_id, Integer
      attribute :created_at, Time
      attribute :updated_at, Time
    end

    collection :people do
      entity     Person
      repository PersonRepository

      attribute :id,   Integer
      attribute :name, String
      attribute :gender, String
      attribute :created_at, Time
      attribute :updated_at, Time
    end

    collection :events do
      entity     Event
      repository EventRepository

      attribute :id,   Integer
      attribute :name, String
      attribute :kind, String
      attribute :created_at, Time
      attribute :updated_at, Time
    end

    collection :moments do
      entity     Moment
      repository MomentRepository

      attribute :id, Integer
      attribute :year_begin, Integer
      attribute :year_end, Integer
      attribute :influencer_id, String
      attribute :influencer_type, String
      attribute :created_at, Time
      attribute :updated_at, Time
    end
  end
end.load!

Hanami::Mailer.configure do
  root "#{__dir__}/pinfluence/mailers"

  # See http://hanamirb.org/guides/mailers/delivery
  delivery do
    development :test
    test        :test
    # production :smtp, address: ENV['SMTP_PORT'], port: 1025
  end
end.load!
