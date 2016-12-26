source 'https://rubygems.org'

gem 'bundler'
gem 'rake'
gem 'hanami',       '~> 0.9'
gem 'hanami-model', '~> 0.7'
gem 'pg'
gem 'httparty'
gem 'sass'
gem 'bcrypt'

group :development do
  # Code reloading
  # See: http://hanamirb.org/guides/applications/code-reloading
  gem 'shotgun'
  gem 'capistrano'
  gem 'capistrano3-puma'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-rbenv'
end

group :test, :development do
  gem 'dotenv', '~> 2.0'
end

group :test do
  gem 'rspec'
  gem 'capybara'
  gem 'factory_girl'
  gem 'byebug'
end

group :production do
  gem 'puma'
end
