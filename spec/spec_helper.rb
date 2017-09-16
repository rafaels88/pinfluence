# Require this file for unit tests
ENV['HANAMI_ENV'] ||= 'test'

require_relative '../config/environment'
require_relative './database_cleaner_helper'
require_relative './factory_girl_helper'
require 'byebug'

Hanami.boot
Hanami::Utils.require!('spec/support')

RSpec.configure do |c|
  c.include Helpers
end
