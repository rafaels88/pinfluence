require 'bundler/setup'
require 'hanami/setup'
require 'hanami/model'
require_relative '../lib/pinfluence'
require_relative '../apps/api/application'
require_relative '../apps/admin/application'
require_relative '../apps/web/application'

Hanami.configure do
  mount Api::Application, at: '/api'
  mount Admin::Application, at: '/admin'
  mount Web::Application, at: '/'

  model do
    adapter :sql, ENV['DATABASE_URL']
    migrations 'db/migrations'
    schema     'db/schema.sql'
  end

  mailer do
    root Hanami.root.join("lib", "pinfluence", "mailers")
    delivery do
      development :test
      test        :test
      # production :smtp, address: ENV['SMTP_PORT'], port: 1025
    end
  end
end
