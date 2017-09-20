# Require this file for feature tests
require 'capybara/rspec'
require_relative './spec_helper'

require 'capybara'
require 'capybara/dsl'

Capybara.app = Hanami.app
Capybara.javascript_driver = :webkit
