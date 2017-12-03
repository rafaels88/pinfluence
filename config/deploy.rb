# config valid only for current version of Capistrano
lock ENV['DEPLOY_CAPISTRANO_VERSION']

set :application, 'pinfluence'
set :repo_url, 'git@github.com:rafaels88/pinfluence.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :linked_files, [ENV['DEPLOY_LINKED_FILE_01']]
set :linked_dirs, [ENV['DEPLOY_LINKED_DIR_01'], ENV['DEPLOY_LINKED_DIR_02'], ENV['DEPLOY_LINKED_DIR_03']]

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, ENV['DEPLOY_RBENV_RUBY']
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} " \
  "#{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w[rake gem bundle ruby rails]
set :rbenv_roles, :all # default value

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, ENV['DEPLOY_PROJECT_PATH']

set :ssh_options,
    forward_agent: true,
    port: ENV['DEPLOY_SSH_PORT']

set :bundle_without, %i[darwin development test]
set :bundle_flags, '--deployment'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :info

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache',
#  'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: '/opt/ruby/bin:$PATH' }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  task :install_bundler do
    on roles(:app), in: :sequence, wait: 5 do
      execute "RBENV_ROOT=$HOME/.rbenv RBENV_VERSION=#{ENV['DEPLOY_RBENV_RUBY']} " \
        '$HOME/.rbenv/bin/rbenv exec gem install bundler --no-document'
    end
  end

  task :precompile do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cd #{current_path} && HANAMI_ENV=#{ENV['DEPLOY_ENV']} #{fetch(:rbenv_prefix)} " \
        'bundle exec hanami assets precompile'
    end
  end

  task :db_migrate do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cd #{current_path} && HANAMI_ENV=#{ENV['DEPLOY_ENV']} #{fetch(:rbenv_prefix)} " \
        'bundle exec hanami db migrate'
    end
  end

  before :updating, :install_bundler
  after :publishing, :db_migrate
  after :publishing, :precompile
end

namespace :index do
  task :all_influencers do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cd #{current_path} && HANAMI_ENV=#{ENV['DEPLOY_ENV']} #{fetch(:rbenv_prefix)} " \
        'bundle exec rake index_all_influencers'
    end
  end
end

namespace :db do
  task :update_all_moments do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cd #{current_path} && HANAMI_ENV=#{ENV['DEPLOY_ENV']} #{fetch(:rbenv_prefix)} " \
        'bundle exec rake update_all_moments'
    end
  end

  task :seed_from_production do
    on roles(:app), in: :sequence, wait: 5 do
      remote_dir_db = '/home/deploy/db-backups/pinfluence'

      puts 'Downloading last production dump...'
      last_dump_backup = capture "ls -tr #{remote_dir_db} | tail -1"
      # download! "#{remote_dir_db}/#{last_dump_backup}", '/tmp/'
      puts "Done! Check in /tmp/#{last_dump_backup}"

      puts 'Recreating database...'
      system 'be hanami db drop create'

      sleep 3

      puts 'Restoring db...'
      system "psql #{ENV['DATABASE_NAME']} < /tmp/#{last_dump_backup}"

      puts 'Done!'

      system 'bundle exec rake index_all_influencers'
    end
  end
end
