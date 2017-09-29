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
  Influencers::Indexer.new(influencers: people, index_object: Influencers::PersonIndexObject).save

  Hanami.logger.debug 'Fetching all events from database...'
  events = EventRepository.new.all
  Hanami.logger.debug 'Indexing...'
  Influencers::Indexer.new(influencers: events, index_object: Influencers::EventIndexObject).save
  Hanami.logger.debug 'Done!'
end

task update_all_moments: :environment do
  Hanami.logger.debug 'Fetching all moments from database...'
  moments = MomentRepository.new.all_with_influencers

  Hanami.logger.debug 'Updating...'
  moments.each do |moment|
    influencer = moment.influencer

    UpdateMoment.call(
      moment: { year_begin: moment.year_begin, year_end: moment.year_end, id: moment.id },
      influencer: { type: influencer.type, id: influencer.id },
      locations: []
    )
  end
end
