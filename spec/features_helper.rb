# Require this file for feature tests
require 'capybara/rspec'
require_relative './spec_helper'
require_relative './vcr_setup'

require 'capybara'
require 'capybara/dsl'

Capybara.app = Hanami.app
Capybara.javascript_driver = :webkit
