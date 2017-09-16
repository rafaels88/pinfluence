require 'dotenv'
Dotenv.load!('.env.development')

# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#

require 'capistrano/bundler'
require 'capistrano/puma'
# require 'capistrano/puma/workers' # if you want to control the workers (in cluster mode)
# require 'capistrano/puma/jungle'  # if you need the jungle tasks
# require 'capistrano/puma/monit'   # if you need the monit tasks
# require 'capistrano/puma/nginx'   # if you want to upload a nginx site template

# require 'capistrano/rvm'
require 'capistrano/rbenv'
# require 'capistrano/chruby'
# require 'capistrano/rails'
# require 'capistrano/passenger'
# require 'capistrano3/unicorn'
# require 'capistrano/sitemap_generator'

# Load custom tasks from `lib/capistrano/tasks' if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
