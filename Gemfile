source 'https://rubygems.org'

gem 'bundler'
gem 'rake'
gem 'hanami',       '0.7.3'
gem 'hanami-model', '0.6.1'
gem 'pg'
gem 'httparty'
gem 'bcrypt'

group :development, :test do
  gem 'byebug'
end

group :development do
  gem 'capistrano'
  gem 'capistrano3-puma'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-rbenv'
end

group :test do
  gem 'minitest'
  gem 'capybara'
end

group :production do
  gem 'puma'
end
