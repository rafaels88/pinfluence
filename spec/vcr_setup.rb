require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/support/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.default_cassette_options = { record: :new_episodes }
  config.ignore_localhost = true
  config.configure_rspec_metadata!
end
