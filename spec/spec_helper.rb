# Require this file for unit tests
ENV['HANAMI_ENV'] ||= 'test'

require_relative '../config/environment'
require_relative './database_cleaner_helper'
require_relative './factory_girl_helper'

Hanami.boot
Hanami::Utils.require!("spec/support")
