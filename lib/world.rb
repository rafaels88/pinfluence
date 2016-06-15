require 'hanami/model'
require 'hanami/mailer'
require_relative './ext/lat_lng'
require_relative './ext/password'

Dir["#{ __dir__ }/world/**/*.rb"].each { |file| require_relative file }

Hanami::Model.configure do
  ##
  # Database adapter
  #
  # Available options:
  #
  #  * Memory adapter
  #    adapter type: :memory, uri: 'memory://localhost/world_development'
  #
  #  * SQL adapter
  #    adapter type: :sql, uri: 'sqlite://db/world_development.sqlite3'
  #    adapter type: :sql, uri: 'postgres://localhost/world_development'
  #    adapter type: :sql, uri: 'mysql://localhost/world_development'
  #
  adapter type: :sql, uri: ENV['WORLD_DATABASE_URL']

  ##
  # Database mapping
  #
  mapping "#{__dir__}/config/mapping"
end.load!

Hanami::Mailer.configure do
  root "#{ __dir__ }/world/mailers"

  # See http://hanamirb.org/guides/mailers/delivery
  delivery do
    development :test
    test        :test
    # production :stmp, address: ENV['SMTP_PORT'], port: 1025
  end
end.load!
