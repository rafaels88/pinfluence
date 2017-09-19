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
    root Hanami.root.join('lib', 'pinfluence', 'mailers')

    delivery :test
  end

  environment :development do
    logger level: :debug
  end

  environment :production do
    logger level: :info, formatter: :json

    mailer do
      delivery :smtp, address: ENV['SMTP_HOST'], port: ENV['SMTP_PORT']
    end
  end
end
