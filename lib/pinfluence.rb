require 'hanami/model'
require 'hanami/mailer'
require_relative './ext/lat_lng'
require_relative './ext/password'

Dir["#{ __dir__ }/pinfluence/**/*.rb"].each { |file| require_relative file }

Hanami::Model.configure do
  ##
  # Database adapter
  #
  # Available options:
  #
  #  * Memory adapter
  #    adapter type: :memory, uri: 'memory://localhost/pinfluence_development'
  #
  #  * SQL adapter
  #    adapter type: :sql, uri: 'sqlite://db/pinfluence_development.sqlite3'
  #    adapter type: :sql, uri: 'postgres://localhost/pinfluence_development'
  #    adapter type: :sql, uri: 'mysql://localhost/pinfluence_development'
  #
  adapter type: :sql, uri: ENV['PINFLUENCE_DATABASE_URL']

  ##
  # Database mapping
  #
  mapping "#{__dir__}/config/mapping"
end.load!

Hanami::Mailer.configure do
  root "#{ __dir__ }/pinfluence/mailers"

  # See http://hanamirb.org/guides/mailers/delivery
  delivery do
    development :test
    test        :test
    # production :stmp, address: ENV['SMTP_PORT'], port: 1025
  end
end.load!
