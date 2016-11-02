source 'https://rubygems.org'

gem 'bundler'
gem 'rake'
gem 'hanami',       '~> 0.8'
gem 'hanami-model', '~> 0.6'

# To use form fields_for for collections
gem "hanami-controller", github: "TiteiKo/controller", branch: "array-items-access-in-params"
gem "hanami-helpers", github: "TiteiKo/helpers", branch: "add-form-array-support"

gem 'pg'
gem 'httparty'
gem 'sass'

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
  gem 'byebug'
end

group :test do
  gem 'minitest'
  gem 'capybara'
end

group :production do
  gem 'puma'
end
