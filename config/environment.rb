require 'bundler/setup'
require 'hanami/setup'
require_relative '../lib/pinfluence'
require_relative '../apps/api/application'
require_relative '../apps/admin/application'
require_relative '../apps/web/application'

Hanami::Container.configure do
  mount Api::Application, at: '/api'
  mount Admin::Application, at: '/admin'
  mount Web::Application, at: '/'
end
