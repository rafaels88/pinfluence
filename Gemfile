source 'https://rubygems.org'

gem 'rake'
gem 'hanami',       '~> 1.0'
gem 'hanami-model', '~> 1.0'
gem 'pg'
gem 'httparty'
gem 'sass'
gem 'bcrypt'
gem 'graphql'

group :development do
  # Code reloading
  # See: http://hanamirb.org/guides/applications/code-reloading
  gem 'byebug'
  gem 'shotgun'
  gem 'capistrano'
  gem 'capistrano3-puma'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-rbenv'
  gem 'guard'
  gem 'guard-rspec', require: false
end

group :test, :development do
  gem 'dotenv', '~> 2.0'
end

group :test do
  gem 'rspec'
  gem 'capybara'
  gem 'factory_girl'
end

group :production do
  gem 'puma'
end
