require 'rake'
require 'hanami/rake_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.libs << 'spec'
  t.warning = false
end

task default: :test
task spec: :test

task index_all_people: :environment do
  Hanami.logger.debug 'Fetching all people from database...'
  people = PersonRepository.new.all
  Hanami.logger.debug 'Indexing...'
  Influencers::Indexer.new(influencers: people).save
  Hanami.logger.debug 'Done!'
end
